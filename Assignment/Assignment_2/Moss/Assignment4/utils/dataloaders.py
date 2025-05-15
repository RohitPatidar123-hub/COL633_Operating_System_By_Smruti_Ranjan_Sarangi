from utils.clevrdataset import ClevrDataset
from torch.utils.data import DataLoader

def get_dataloaders(train_json, train_img_dir, val_json, val_img_dir, tokenizer, answer2idx_train, image_transform, BATCH_SIZE):

    train_dataset = ClevrDataset(
        json_path=train_json,  
        images_dir=train_img_dir,  
        tokenizer=tokenizer,
        answer2idx=answer2idx_train,
        max_len=50,
        transform=image_transform
    )

    if val_json:
        val_dataset = ClevrDataset(
            json_path=val_json,  
            images_dir=val_img_dir,  
            tokenizer=tokenizer,
            answer2idx=answer2idx_train,  
            max_len=50,
            transform=image_transform  
        )

    train_loader = DataLoader(
        train_dataset,
        batch_size=BATCH_SIZE,
        shuffle=True,
        num_workers=2,
        pin_memory=True
    )

    val_loader = None
    
    if val_json:
        val_loader = DataLoader(
            val_dataset,
            batch_size=BATCH_SIZE,
            shuffle=False,  
            num_workers=2,
            pin_memory=True
        )

    return train_loader, val_loader