import argparse
import os
from trainingloop import training_loop

def inference(dataset_path, model_path, part):
    print(f"[{part}] Inference on dataset: {dataset_path}")
    print(f"Using model: {model_path}")
    test_json = f'{dataset_path}/questions/CLEVR_testB_questions.json'
    test_img_dir = f'{dataset_path}/images/testB'
    eval(test_json, test_img_dir, dataset_path, model_path = model_path)

def main():
    parser = argparse.ArgumentParser(description="Inference script")
    parser.add_argument('--mode', required=True, choices=['train', 'inference'], help='train or inference')
    parser.add_argument('--dataset', required=True, help='Path to dataset')
    parser.add_argument('--model', required=('inference' in os.sys.argv or 'train' in os.sys.argv and 'part8.py' not in os.path.basename(__file__)), help='Path to model')

    args = parser.parse_args()
    part = os.path.basename(__file__).replace(".py", "")

    if args.mode == 'inference':
        inference(args.dataset, args.model, part)

if __name__ == "__main__":
    main()
