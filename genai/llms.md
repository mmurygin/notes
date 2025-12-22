# LLMs

A **language model** is a type of artificial intelligence system that is trained to understand and generate human-like text. It learns the structure, grammar, and semantics of a language by processing vast amounts of textual data. **The primary goal** of a language model is to **predict the next word or token** in a sequence based on the context provided by previous words.

## Transformer Architecture

The transformer is the foundational architecture behind modern LLMs like GPT, Claude, and BERT. Think of it as a sophisticated pattern-matching and prediction engine that processes text in parallel rather than sequentially.

### High-Level Architecture

```
Input: "The cat sat on the"
         ↓
    [Tokenization]
         ↓
    [Embeddings] ← Convert tokens to vectors
         ↓
    [Position Encoding] ← Add position information
         ↓
    ╔════════════════════════════════════════╗
    ║        TRANSFORMER BLOCK               ║
    ║  ┌──────────────────────────────────┐  ║
    ║  │   Multi-Head Attention           │  ║
    ║  │   (What tokens relate to what?)  │  ║
    ║  └──────────────────────────────────┘  ║
    ║              ↓                          ║
    ║  ┌──────────────────────────────────┐  ║
    ║  │   Add & Normalize                │  ║
    ║  └──────────────────────────────────┘  ║
    ║              ↓                          ║
    ║  ┌──────────────────────────────────┐  ║
    ║  │   Feed Forward Network           │  ║
    ║  │   (Transform representations)    │  ║
    ║  └──────────────────────────────────┘  ║
    ║              ↓                          ║
    ║  ┌──────────────────────────────────┐  ║
    ║  │   Add & Normalize                │  ║
    ║  └──────────────────────────────────┘  ║
    ╚════════════════════════════════════════╝
         ↓
    [Repeat N times] ← Stack 12-96+ blocks
         ↓
    [Output Layer] ← Probability distribution
         ↓
    Prediction: "mat" (highest probability)
```

### Core Components Explained

#### 1. Tokenization & Embeddings

**Think of it as:** Converting strings to numerical vectors that capture semantic meaning.

```
"cat" → [0.2, -0.5, 0.8, 0.1, ...] (512-4096 dimensions)
"dog" → [0.3, -0.4, 0.7, 0.2, ...] (similar vector, close in space)
"car" → [-0.1, 0.9, -0.3, 0.6, ...] (different vector, far from "cat")
```

The embedding layer is essentially a giant lookup table: `token_id → vector`. These vectors are learned during training so that semantically similar words end up close together in vector space.

#### 2. Position Encoding

**Problem:** Unlike RNNs that process sequences step-by-step, transformers process all tokens in parallel. But word order matters!

**Solution:** Add positional information to each token's embedding using sine/cosine functions:

```
position_encoding[pos][2i]   = sin(pos / 10000^(2i/d))
position_encoding[pos][2i+1] = cos(pos / 10000^(2i/d))
```

This creates a unique "fingerprint" for each position that the model can learn to use.

#### 3. Multi-Head Attention (The Core Innovation)

**Think of it as:** A sophisticated dictionary lookup where each word asks "which other words should I pay attention to?"

**Detailed View:**

```
For input token "sat":
┌─────────────────────────────────────────────────────┐
│ Query (Q): "What am I looking for?"                 │
│ Key (K):   "What do I contain?" (for all tokens)   │
│ Value (V): "What information do I carry?"           │
└─────────────────────────────────────────────────────┘

Attention(Q, K, V) = softmax(Q·K^T / √d_k) · V

Example: Analyzing "The cat sat on the mat"

Token "sat" queries all other tokens:
  "The" ─────┬──→ Attention Score: 0.05
  "cat" ─────┼──→ Attention Score: 0.40  (high!)
  "sat" ─────┼──→ Attention Score: 0.10
  "on"  ─────┼──→ Attention Score: 0.15
  "the" ─────┼──→ Attention Score: 0.05
  "mat" ─────┴──→ Attention Score: 0.25  (high!)

Result: "sat" pays most attention to "cat" and "mat"
```

**Multi-Head:** Run attention mechanism multiple times in parallel (8-16 "heads"), each learning different relationships:
- Head 1: Might learn subject-verb relationships
- Head 2: Might learn semantic similarities
- Head 3: Might learn syntactic dependencies
- etc.

**Software Engineering Analogy:**
```python
# Pseudo-code to understand attention
def attention(query, keys, values):
    # Compute similarity scores (dot product)
    scores = query @ keys.T / sqrt(dimension)

    # Normalize to probabilities
    weights = softmax(scores)  # [0.4, 0.05, 0.1, 0.15, 0.05, 0.25]

    # Weighted sum of values
    output = weights @ values
    return output
```

#### 4. Feed Forward Network

After attention, each token representation is passed through a simple 2-layer neural network:

```
FFN(x) = ReLU(x · W1 + b1) · W2 + b2
```

**Purpose:** Transform and enrich the representations. If attention is "gather information from other tokens," FFN is "process that information."

**Dimensions:** Typically expands dimension by 4x (e.g., 768 → 3072 → 768), allowing complex non-linear transformations.

#### 5. Add & Normalize (Residual Connections)

**Residual Connection:**
```
output = LayerNorm(input + Sublayer(input))
```

**Why?**
- Helps gradients flow during training (like skip connections in ResNet)
- Allows deep networks (100+ layers) to train effectively
- Prevents the "vanishing gradient" problem

### How It All Works Together

**Step-by-step processing of "The cat sat":**

1. **Input:** Tokens [The, cat, sat] → IDs [42, 156, 234]

2. **Embedding + Position:**
   ```
   [42] → [0.2, 0.5, ...] + [sin/cos positions for pos 0]
   [156] → [0.3, 0.4, ...] + [sin/cos positions for pos 1]
   [234] → [-0.1, 0.7, ...] + [sin/cos positions for pos 2]
   ```

3. **Attention (Layer 1):**
   - "cat" looks at "The" and learns it's the determiner
   - "sat" looks at "cat" and learns it's the subject
   - Each token's representation is updated with context

4. **FFN (Layer 1):**
   - Transform representations non-linearly
   - Each token processed independently

5. **Repeat 2-3 for N layers** (12, 24, 96, etc.)
   - Early layers: Learn syntax, grammar, word relationships
   - Middle layers: Learn semantic meaning, context
   - Late layers: Learn task-specific patterns, reasoning

6. **Output:**
   - Final representation → probability distribution over vocabulary
   - Pick token with highest probability

### Key Insights for Software Engineers

**Parallel Processing:**
- Unlike for-loops that process sequences step-by-step, transformers process all tokens simultaneously
- Makes them fast on GPUs (matrix multiplications are highly parallelizable)
- Think: `map()` instead of sequential `for` loop

**Memory & Context:**
- Attention mechanism has O(n²) complexity where n = sequence length
- Each token can theoretically attend to every other token
- Modern optimizations (sliding windows, sparse attention) reduce this

**Training vs Inference:**
- Training: Use "teacher forcing" - know the correct next token
- Inference: Autoregressive - generate one token at a time, feed it back
- Like recursion: output becomes input for next iteration

**Scale is Critical:**
- More layers → deeper understanding
- More heads → richer relationships
- Larger embeddings → more nuanced representations
- More data → better generalization

### Decoder-Only vs Encoder-Decoder

**Encoder-Only (BERT):**
- Bidirectional: sees entire sequence at once
- Good for: classification, understanding tasks
- Like reading a document to extract information

**Decoder-Only (GPT, Claude):**
- Unidirectional: only sees previous tokens (causal masking)
- Good for: text generation
- Like writing a story one word at a time

**Encoder-Decoder (T5):**
- Encoder processes input, decoder generates output
- Good for: translation, summarization
- Like reading a book (encoder) then writing a summary (decoder)

### Why Transformers Won

**Before Transformers (RNNs/LSTMs):**
- Sequential processing: slow, can't parallelize
- Limited context: hard to remember distant tokens
- Gradient issues: vanishing/exploding gradients

**Transformers:**
- Parallel processing: fast training on GPUs
- Attention: direct connections between all tokens
- Scalable: just stack more layers
- Self-attention learns what's relevant automatically

### Practical Implications

**Context Window:**
- Limited by memory (n² attention complexity)
- GPT-3: 2K tokens, GPT-4: 128K tokens, Claude: 200K tokens
- Think: function call with limited parameter buffer

**Emergence:**
- Small models: pattern matching
- Large models: reasoning, planning, complex understanding
- Like the difference between a hash map and a graph database

**Inference Cost:**
- Each token generation requires full forward pass
- More layers/parameters = slower inference
- Trade-off: capability vs latency
