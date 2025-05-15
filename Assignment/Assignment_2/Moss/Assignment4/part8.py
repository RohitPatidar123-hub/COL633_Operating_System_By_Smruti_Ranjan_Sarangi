import argparse
from trainingloop import training_loop

def train(dataset_path, save_path):

    print(f"[Part 8] Training with dataset: {dataset_path}")
    print(f"Saving model/results to: {save_path}")

    train_json = f'{dataset_path}/questions/CLEVR_trainA_questions.json'
    train_img_dir = f'{dataset_path}/images/trainA'

    training_loop(dataset_path, train_json, train_img_dir, save_path=save_path, LOSS='CE', model_path = None, USE_EMBEDDING = False)

def inference(dataset_path, model_path):
    print(f"[Part 8] Running inference on dataset: {dataset_path}")
    print(f"Using model from: {model_path}")
    test_json = f'{dataset_path}/questions/CLEVR_testA_questions.json'
    test_img_dir = f'{dataset_path}/images/testA'
    eval(test_json, test_img_dir, dataset_path, model_path = model_path)

def main():
    parser = argparse.ArgumentParser(description="Part 8 script: Train and Inference")
    parser.add_argument('--mode', required=True, choices=['train', 'inference'])
    parser.add_argument('--dataset', required=True, help='Path to dataset')
    parser.add_argument('--save', help='Path to save model/results (required for training)')
    parser.add_argument('--model', help='Path to model (required for inference)')

    args = parser.parse_args()

    if args.mode == 'train':
        if not args.save:
            raise ValueError("--save is required in training mode.")
        train(args.dataset, args.save)
    elif args.mode == 'inference':
        if not args.model:
            raise ValueError("--model is required in inference mode.")
        inference(args.dataset, args.model)

if __name__ == "__main__":
    main()
