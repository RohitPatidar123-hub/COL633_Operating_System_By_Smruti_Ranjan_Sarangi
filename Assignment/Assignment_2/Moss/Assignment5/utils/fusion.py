import torch.nn as nn

class FeatureFusion(nn.Module):
    def __init__(self):
        super().__init__()
        self.image_proj = nn.Linear(768, 768)
        self.cross_attn = nn.MultiheadAttention(embed_dim=768, num_heads=8)
        
    def forward(self, image_features, text_cls_token):
        
        B, C, h, w = image_features.size()
        image_permuted = image_features.permute(0, 2, 3, 1)  
        image_proj = self.image_proj(image_permuted)          
        image_proj = image_proj.permute(0, 3, 1, 2)           
        
        image_flat = image_proj.reshape(B, 768, h * w)        
        image_flat = image_flat.permute(2, 0, 1)              
        
        text_query = text_cls_token.unsqueeze(0)              
        
        fused_feature, _ = self.cross_attn(
            query=text_query,
            key=image_flat,
            value=image_flat
        )  
        
        return fused_feature.squeeze(0)