import torch.nn as nn
import torch


class TextTransformer(nn.Module):
    def __init__(self, vocab_size, max_len):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, 768)
        self.cls_token = nn.Parameter(torch.randn(1, 1, 768))
        self.positional_embeddings = nn.Parameter(torch.randn(1, max_len + 1, 768))
        encoder_layer = nn.TransformerEncoderLayer(d_model=768, nhead=8)
        self.transformer_encoder = nn.TransformerEncoder(encoder_layer, num_layers=6)
        
    def forward(self, input_ids):
        batch_size, seq_len = input_ids.size()
        word_embeds = self.embedding(input_ids)  
        cls_token = self.cls_token.expand(batch_size, -1, -1)
        embeddings = torch.cat([cls_token, word_embeds], dim=1)  
        
        embeddings += self.positional_embeddings[:, :seq_len + 1, :]
        
        embeddings = embeddings.permute(1, 0, 2)  
        output = self.transformer_encoder(embeddings)
        return output[0]  