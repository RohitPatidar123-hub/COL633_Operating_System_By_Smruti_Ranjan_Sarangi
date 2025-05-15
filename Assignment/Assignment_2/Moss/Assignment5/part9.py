import argparse
import os
from trainingloop import training_loop

def train(dataset_path, model_path, save_path, part):
    print(f"[{part}] Training with dataset: {dataset_path}")
    print(f"Using model: {model_path}")
    print(f"will save model/results to: {save_path}")
    train_json = f'{dataset_path}/questions/CLEVR_trainA_questions.json'
    train_img_dir = f'{dataset_path}/images/trainA'
    training_loop(train_json, train_img_dir, dataset_path, save_path=save_path, LOSS='CE', model_path = model_path, USE_EMBEDDING = False)

def inference(dataset_path, model_path, part):
    print(f"[{part}] Inference on dataset: {dataset_path}")
    print(f"Using model: {model_path}")
    test_json = f'{dataset_path}/questions/CLEVR_testA_questions.json'
    test_img_dir = f'{dataset_path}/images/testA'
    eval(test_json, test_img_dir, dataset_path, model_path = model_path)

def main():
    parser = argparse.ArgumentParser(description="Training/Inference script")
    parser.add_argument('--mode', required=True, choices=['train', 'inference'], help='train or inference')
    parser.add_argument('--dataset', required=True, help='Path to dataset')
    parser.add_argument('--model', required=('inference' in os.sys.argv or 'train' in os.sys.argv and 'part8.py' not in os.path.basename(__file__)), help='Path to model')
    parser.add_argument('--save', help='Path to save model/results (only for training)')

    args = parser.parse_args()
    part = os.path.basename(__file__).replace(".py", "")

    if args.mode == 'train':
        if not args.save:
            raise ValueError("Save path required for training.")
        train(args.dataset, args.model, args.save, part)

    elif args.mode == 'inference':
        inference(args.dataset, args.model, part)

if __name__ == "__main__":
    main()
