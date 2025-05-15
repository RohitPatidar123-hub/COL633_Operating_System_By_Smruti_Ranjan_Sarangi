import torch.nn as nn
import torchvision.models as models

class ImageEncoder(nn.Module):
    def __init__(self):
        super().__init__()
        resnet = models.resnet101(pretrained=True)
        self.resnet = nn.Sequential(*list(resnet.children())[:-2])
        self.projection = nn.Conv2d(2048, 768, kernel_size=1)
        for param in self.resnet.parameters():
            param.requires_grad = False
            
    def forward(self, x):
        features = self.resnet(x)          
        projected = self.projection(features) 
        return projected