import json
from pathlib import Path
from transformers import BertTokenizer, BertModel
from PIL import Image
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader, random_split
from torchvision import transforms
from torch.optim import AdamW
from tqdm import tqdm
from torch.nn import CrossEntropyLoss
from sklearn.metrics import classification_report, accuracy_score, precision_recall_fscore_support
import pandas as pd
import matplotlib.pyplot as plt
from collections import OrderedDict
import torch.nn.functional as F
from torchvision.models import resnet101
import argparse


def text_encoder(input):
    size, len = input.size()
    embed = torch.cat((cls_token.expand(size, -1, -1), embedding(input)), dim=1) + positional_embeddings[:, :len + 1, :]
    return transformer_encoder(embed.permute(1, 0, 2))[0]

class FLLoss(nn.Module):
    def __init__(self):
        super().__init__()

    def forward(self, logs, expected, alpha=1, gamma=2.0, reduction='mean'):
        exp = (torch.exp(F.log_softmax(logs, dim=1))).gather(1, expected.unsqueeze(1)).squeeze(1)
        log = (F.log_softmax(logs, dim=1)).gather(1, expected.unsqueeze(1)).squeeze(1)
        loss = -alpha * (1 - exp) ** gamma * log
        mean = loss.mean()
        sum = loss.sum()
        if reduction == 'sum':
            return sum
        elif reduction == 'mean':
            return mean
        else:
            return loss

# False for part 8
res = resnet101(pretrained=False)
image_extractor = nn.Sequential(*list(res.children())[:-2])
for param in image_extractor.parameters():
    # Freeze for part 8
    param.requires_grad = False
# project the output to 768
conv = nn.Conv2d(2048, 768, kernel_size=1)
        
def encode_image(input, pretrained=False, grads=False): return conv(res(input))

def fuse_image_text(img, text):
    img = encode_image(img)
    B, _, H, W = img.size()
    proj = nn.Linear(768, 768)
    img = ((proj(img.permute(0, 2, 3, 1)).permute(0, 3, 1, 2)).reshape(B, 768, H * W)).permute(2, 0, 1)
    attn = nn.MultiheadAttention(embed_dim=768, num_heads=8)
    return (attn(query=text_encoder(text).unsqueeze(0), key=img, val=img)[0]).squeeze(0)

def get_classifier(classes):
    classifier = nn.Sequential(
        nn.Linear(768, 500),
        nn.ReLU(),
        nn.Linear(500, classes)
    )
    for layer in classifier:
        if isinstance(layer, nn.Linear):
            nn.init.kaiming_normal_(layer.weight, nonlinearity='relu')
            if layer.bias is not None: nn.init.constant_(layer.bias, 0)

    return classifier
    
def classify(classifier, image, text): return classifier(fuse_image_text(image, text))

class Model(nn.Module):
    def __init__(self, classes):
        super().__init__()
        self.classifier = get_classifier(classes)

    def forward(self, image, text): return classify(self.classifier, image, text)
    
class QuestionAnswerDataset(Dataset):
    def __init__(self, img_dir, question, transform=None):
        self.transform = transform
        self.file, self.ques, self.ans = self.load_data(question)
        self.img_dir = img_dir
        self.input_ids, self.attention_mask = self.tokenize(self.ques)
        
    def tokenize(self, questions):
        text_tokens = tokenizer(questions, padding='max_length', truncation=True, max_length=len_max, return_tensors='pt', return_attention_mask=True, add_special_tokens=False)
        return text_tokens["input_ids"], text_tokens["attention_mask"]
        
    def load_data(self, path):
        with open(path, 'r') as f:
            data = json.load(f)
            data = data['questions']
            
        answers = [d["answer"] for d in data]
        ans = []
        for a in answers:
            if a in answer_idx_map:
                ans.append(answer_idx_map[a])
        
        filenames = [d["image_filename"] for d in data]
        questions = [d["question"] for d in data]
        return filenames, questions, torch.tensor(ans)
        
    def __len__(self):
        return len(self.ans)

    def __getitem__(self, idx):
        img = Image.open(f'{self.images_dir}/{self.filenames[idx]}').convert('RGB')
        if self.transform:
            img = self.transform(img)
        map = {
            "image": img,
            "answer": self.ans[idx],
            "input_ids": self.input_ids[idx],
            "attention_mask": self.attention_mask[idx]
        }
        return map
    
tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")

#define some fixed variables for training
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
img_size = 224
batch = 32
epochs = 4
l_rate = 3e-5

image_transform = transforms.Compose([
        transforms.Resize((img_size, img_size)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

# Load the dataset
vocab_len = tokenizer.vocab_size
len_max = 50
embedding = nn.Embedding(vocab_len, 768)
cls_token = nn.Parameter(torch.randn(1, 1, 768))
positional_embeddings = nn.Parameter(torch.randn(1, len_max + 1, 768))
encoder_layer = nn.TransformerEncoderLayer(d_model=768, nhead=8)
transformer_encoder = nn.TransformerEncoder(encoder_layer, num_layers=6)

saved_model = None
model_saving_path = "model.pth"

print()
print("#" * 30)
print("Loading model...")
model = Model(len(answers)).to(device)

if saved_model:
    model.load_state_dict(torch.load(saved_model, map_location=device))
    print("Model loaded")

# loss = FLLoss()
loss = CrossEntropyLoss()
optimizer = AdamW(model.parameters(), lr=l_rate)

def train(model, optimizer, loss, load_train):
    model.train()
    for epoch in range(epochs):
        print(f"Epoch {epoch + 1}/{epochs}")
        running_loss = 0.0
        correct = 0
        total = 0
        prog = tqdm(load_train, desc=f"Training epoch: {epoch+1}", ascii=True, mininterval=50)
        
        for b in prog:
            optimizer.zero_grad()
            ans = b["answer"].to(device)
            img = b["image"].to(device)
            txt = b["input_ids"].to(device)
            output = model(img, txt)
            loss_value = loss(output, ans)
            loss_value.backward()
            optimizer.step()
            # Calculate loss
            total += ans.size(0)
            _, predicted = torch.max(output.data, 1)
            correct += (predicted == ans).sum().item()
            running_loss += loss_value.item()
            
        print(f"Epoch {epoch + 1}: ")    
        print(f"Train loss: {running_loss / len(load_train):.4f}")
        print(f"Train accuracy: {correct / total:.4f}")
        
    torch.save(model.state_dict(), model_saving_path)
    
def eval(model, load_val):
    model.eval()
    preds = []
    lbls = []
    
    with torch.no_grad():
        for b in load_val:
            ans = b["answer"].to(device)
            img = b["image"].to(device)
            txt = b["input_ids"].to(device)
            output = model(img, txt)
            _, predicted = torch.argmax(output, 1)
            preds.extend(predicted.cpu().numpy())
            lbls.extend(ans.cpu().numpy())
            
    idx2answer = {v: k for k, v in answer_idx_map.items()}
    targets = [idx2answer[i] for i in range(len(answer_idx_map))]
    print(classification_report(lbls, preds, target_names=targets, zero_division=0))
    
    print(f"Accuracy: {accuracy_score(lbls, preds):.4f}")
    prec, recall, f1 = precision_recall_fscore_support(lbls, preds, average='weighted', zero_division=0)
    print(f"Precision: {prec:.4f}")
    print(f"Recall: {recall:.4f}")
    print(f"F1 Score: {f1:.4f}")
    print("Evaluation complete")
    print("#" * 30)
    
    
def get_args():
    parser = argparse.ArgumentParser(description="Part 8")
    parser.add_argument('--mode', required=True, choices=['train', 'inference'])
    parser.add_argument('--dataset', required=True, help='Path to dataset')
    parser.add_argument('--save', help='Path to save model/results (required for training)')
    parser.add_argument('--model', help='Path to model (required for inference)')

    return parser.parse_args()
    
def get_data_loader(img_path, ques_path):
    print("#" * 30)
    print("Loading data...")
    data = QuestionAnswerDataset(img_path, ques_path, transform=image_transform)
    load = DataLoader(data, batch_size=batch, shuffle=True, pin_memory=True, num_workers=2)
    print("Data loaded")
    print("#" * 30)
    return load

def main():
    args = get_args()
    data_dir = args.dataset
    ques = {}
    for data_type in ['train', 'test', 'val']:
        path = f'{data_dir}/questions/CLEVR_{data_type}A_questions.json'
        with open(path, 'r', encoding='utf-8') as f:
            ques[data_type] = json.load(f)
            
    answers = {q["answer"] for q in ques['train']['questions']}
    answers = sorted(answers)
    answer_idx_map = {ans: i for i, ans in enumerate(answers)}
    if args.mode == 'train':
        train_ques_path = f"{args.dataset}/questions/CLEVR_trainA_questions.json"
        train_img_path = f"{args.dataset}/images/train"
        train(model, optimizer, loss, get_data_loader(train_img_path, train_ques_path))
        
    elif args.mode == 'inference':
        
        eval(model, load_val)

if __name__ == "__main__":
    main()