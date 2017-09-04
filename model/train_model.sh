rm -r data
mkdir -p data/train/good
mkdir data/train/bad
mkdir -p data/validation/good
mkdir data/validation/bad
python3 train_model.py
