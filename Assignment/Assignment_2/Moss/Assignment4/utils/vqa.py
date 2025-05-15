import torch.nn as nn
from imageencoder import ImageEncoder
from texttransformer import TextTransformer
from fusion import FeatureFusion
from mlp import MLPClassifier

class VQAModel(nn.Module):
    def __init__(self, num_classes, vocab_size, max_len):
        super().__init__()
        self.image_encoder = ImageEncoder()
        self.text_encoder = TextTransformer(vocab_size=vocab_size, max_len=max_len)
        self.feature_fusion = FeatureFusion()
        self.classifier = MLPClassifier(num_classes=num_classes)

    def forward(self, image, input_ids):
        image_features = self.image_encoder(image)  
        text_cls = self.text_encoder(input_ids)     
        fused_feature = self.feature_fusion(image_features, text_cls)  
        logits = self.classifier(fused_feature)     
        return logits