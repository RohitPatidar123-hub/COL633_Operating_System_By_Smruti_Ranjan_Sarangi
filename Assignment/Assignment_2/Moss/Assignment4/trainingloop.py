from utils.vqa import VQAModel
import torch
import json
from torch.optim import AdamW
from tqdm import tqdm
from utils.floss import FocalLoss
from utils.dataloaders import get_dataloaders
from torchvision import transforms
import pandas as pd
from transformers import BertModel, BertTokenizer
from torch.nn import CrossEntropyLoss


def training_loop(dataset_dir, train_json, train_img_dir, val_json=None, val_img_dir=None,  save_path='best_model.pth', LOSS='CE', model_path = None, USE_EMBEDDING = False):
    
    splits = ['train', 'test', 'val']
    DEVICE = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    IMAGE_SIZE = 224
    BATCH_SIZE = 32
    NUM_EPOCHS = 4
    LEARNING_RATE = 3e-5
    
    
    def path_question(split):
        return f'{dataset_dir}/questions/CLEVR_{split}A_questions.json'

    def build_answer_vocab(entries):
        all_answers = {e["answer"] for e in entries}
        sorted_answers = sorted(all_answers)
        answer2idx = {a: i for i, a in enumerate(sorted_answers)}
        return answer2idx

    questions = {}
    for split in splits:
        with open(path_question(split), 'r', encoding='utf-8') as f:
            questions[split] = json.load(f)

    answer2idx_train = build_answer_vocab(questions['train']['questions'])
    tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")

    image_transform = transforms.Compose([
        transforms.Resize((IMAGE_SIZE, IMAGE_SIZE)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                            std=[0.229, 0.224, 0.225])
    ])

    print('Loading data!')
    train_loader, val_loader = get_dataloaders(train_json, train_img_dir, val_json, val_img_dir, tokenizer, answer2idx_train, image_transform, BATCH_SIZE)
    print('Data Loaded!')

    print("Initializing model")
    model = VQAModel(
        num_classes=len(answer2idx_train),
        vocab_size=tokenizer.vocab_size,
        max_len=50
    ).to(DEVICE)

    if model_path:
        model.load_state_dict(torch.load(model_path, map_location=DEVICE))

    if USE_EMBEDDING:
        bert = BertModel.from_pretrained('bert-base-uncased').to(DEVICE)
        model.text_encoder.embedding = bert.embeddings.word_embeddings  

    optimizer = AdamW(model.parameters(), lr=LEARNING_RATE)
    if LOSS == 'focal': 
        loss_fn = FocalLoss()
    else:
        loss_fn = CrossEntropyLoss()

    print("Training loop started.")

    for epoch in range(NUM_EPOCHS):
        model.train()
        train_loss = 0.0
        correct_train = 0
        total_train = 0

        train_progress = tqdm(train_loader, 
                            desc=f'Epoch {epoch+1}/{NUM_EPOCHS} [Train]',
                            mininterval=50, 
                            ascii=True)     
        for batch in train_progress:
            images = batch['image'].to(DEVICE)
            input_ids = batch['input_ids'].to(DEVICE)
            answers = batch['answer'].to(DEVICE)

            optimizer.zero_grad()
            logits = model(images, input_ids)
            loss = loss_fn(logits, answers)

            loss.backward()
            optimizer.step()

            train_loss += loss.item()
            _, predicted = torch.max(logits.data, 1)
            total_train += answers.size(0)
            correct_train += (predicted == answers).sum().item()

            train_progress.set_postfix({
                'loss': f'{loss.item():.4f}',
                'acc': f'{correct_train/total_train:.4f}'
            })

        avg_train_loss = train_loss / len(train_loader)
        train_acc = correct_train / total_train

        print(f'\nEpoch {epoch+1} Summary:')
        print(f'Train Loss: {avg_train_loss:.4f} | Acc: {train_acc:.4f}')

    torch.save(model.state_dict(), save_path)
