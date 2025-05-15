import torch
from transformers import BertTokenizer
from torchvision import transforms
import json
from utils.vqa import VQAModel
from torch.utils.data import DataLoader
from sklearn.metrics import classification_report, accuracy_score, precision_recall_fscore_support
from utils.clevrdataset import ClevrDataset

def eval(test_json, test_img_dir, dataset_dir, model_path = None):

    splits = ['train', 'test', 'val']
    DEVICE = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    IMAGE_SIZE = 224

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

    print("Initializing model")
    model = VQAModel(
        num_classes=len(answer2idx_train),
        vocab_size=tokenizer.vocab_size,
        max_len=50
    ).to(DEVICE)

    if model:
        model.load_state_dict(torch.load(model_path, map_location=DEVICE))
    else:
        print("Model = None??")
        return

    def evaluate_model(model, test_loader):
        model.eval()
        all_preds = []
        all_labels = []
        
        with torch.no_grad():
            for batch in test_loader:
                input_ids = batch['input_ids'].to(DEVICE)
                attention_mask = batch['attention_mask'].to(DEVICE)
                images = batch['image'].to(DEVICE)
                answers = batch['answer'].to(DEVICE)
                
                outputs = model(
                    image=images,
                    input_ids=input_ids,
                )
                
                preds = torch.argmax(outputs, dim=1)
                all_preds.extend(preds.cpu().numpy())
                all_labels.extend(answers.cpu().numpy())
        
        accuracy = accuracy_score(all_labels, all_preds)
        precision, recall, f1, _ = precision_recall_fscore_support(
            all_labels, all_preds, average='weighted', zero_division=0
        )
        
        idx2answer = {v: k for k, v in answer2idx_train.items()}
        target_names = [idx2answer[i] for i in range(len(answer2idx_train))]
        
        print(f"Accuracy: {accuracy:.4f}")
        print(f"Weighted Precision: {precision:.4f}")
        print(f"Weighted Recall: {recall:.4f}")
        print(f"Weighted F1 Score: {f1:.4f}")
        print("\nClassification Report:")
        print(classification_report(all_labels, all_preds, 
                                    target_names=target_names, zero_division=0))

    image_transform = transforms.Compose([
        transforms.Resize((IMAGE_SIZE, IMAGE_SIZE)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                                std=[0.229, 0.224, 0.225])
    ])

    test_dataset = ClevrDataset(
        json_path=test_json,
        images_dir=test_img_dir,
        tokenizer=tokenizer,
        answer2idx=answer2idx_train,
        max_len=50,
        transform=image_transform
    )

    test_loader = DataLoader(
        test_dataset,
        batch_size=32,
        shuffle=False,
        num_workers=2
    )

    evaluate_model(model, test_loader)