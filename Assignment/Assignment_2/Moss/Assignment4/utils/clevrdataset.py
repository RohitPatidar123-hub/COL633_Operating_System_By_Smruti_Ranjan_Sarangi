from torch.utils.data import Dataset
import torch
import json
from PIL import Image

class ClevrDataset(Dataset):
    def __init__(self, json_path, images_dir, tokenizer, answer2idx, max_len=50, transform=None):
        self.images_dir = images_dir
        self.tokenizer = tokenizer
        self.answer2idx = answer2idx
        self.transform = transform
        self.max_len = max_len  

        with open(json_path) as f:
            entries = json.load(f)['questions']
        
        self.filenames = [e["image_filename"] for e in entries]
        self.questions = [e["question"] for e in entries]
        self.raw_answers = [e["answer"] for e in entries]
        
        self.answers = torch.tensor([self._safe_answer_convert(a) for a in self.raw_answers])
        tokenized = self.tokenizer(
            self.questions,
            add_special_tokens=False,
            max_length=self.max_len,
            padding="max_length",
            truncation=True,
            return_attention_mask=True,
            return_tensors="pt"
        )
        self.input_ids = tokenized["input_ids"]
        self.attention_mask = tokenized["attention_mask"]

    def __len__(self):
        return len(self.answers)

    def _safe_answer_convert(self, answer):
        try:
            return self.answer2idx[answer]
        except KeyError:
            raise ValueError(f"Answer '{answer}' not found in answer2idx mapping")

    def __getitem__(self, idx):
        text_data = {
            "input_ids": self.input_ids[idx],
            "attention_mask": self.attention_mask[idx]
        }

        img_path = f'{self.images_dir}/{self.filenames[idx]}'
        img = Image.open(img_path).convert("RGB")
        
        if self.transform:
            img = self.transform(img)

        return {
            **text_data,
            "image": img,
            "answer": self.answers[idx]
        }