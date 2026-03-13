# Recommendation & ML Systems

## Filtering Approaches
| Type | Technique | Pros | Cons |
|------|-----------|------|------|
| Collaborative (user-user) | Find similar users, borrow ratings | Serendipitous | Sparse matrix, cold start |
| Collaborative (item-item) | Cosine similarity on item vectors | Stable, scalable | Item cold start |
| Matrix Factorization | SVD, ALS (implicit feedback) | Handles sparsity | Expensive retraining |
| Content-Based | TF-IDF, embeddings, feature vectors | No cold start for items | Filter bubble |
| Hybrid | Weighted / switching / cascade | Best accuracy | Complexity |

## Two-Tower Architecture (Google DNN for YouTube)
```
User features → User tower → User embedding ─┐
                                              ├─ dot product → score → ranking
Item features → Item tower → Item embedding ─┘
```
- **Candidate generation**: ANN search (Faiss/ScaNN) over item embeddings, returns top-K
- **Ranking**: Full feature cross model on top-K candidates, returns top-N

## Feature Store
| Concern | Online Store (Redis) | Offline Store (S3/Hive) |
|---------|---------------------|------------------------|
| Latency | <10ms | Minutes/hours |
| Use | Real-time inference | Training, batch scoring |
| Key requirement | Point-in-time correctness (no future leakage) | |

## ML Serving
- **Batch inference**: precompute scores nightly, store in key-value store; low latency at serve time
- **Real-time inference**: model server (TorchServe, TF Serving, Triton); higher latency
- **Model versioning**: shadow mode → canary → full rollout
- **A/B testing**: route % traffic by user_id hash; track CTR, dwell time, conversion

## Cold Start Strategies
| Scenario | Strategy |
|----------|----------|
| New user | Popularity-based, onboarding quiz, content-based from explicit prefs |
| New item | Content-based metadata embeddings, manual curation boost |
| New user + new item | Demographic fallback, trending in category |

## Fraud Detection Pipeline
```
Rule engine (fast, cheap) → ML scoring (gradient boosting / neural) → Human review queue
       ↓ block obvious                ↓ score > threshold                    ↓ appeals
```
- Features: velocity (txn/hour), device fingerprint, geo mismatch, graph features
- Near-real-time: Kafka → Flink → score → decision in <100ms

## Content Moderation Pipeline
```
Hash matching (PhotoDNA/MD5) → ML classifier (text/image/video) → Human review queue → Appeals
        ↓ known bad                   ↓ confidence < threshold
```
- **Hash matching**: exact & near-duplicate detection, O(1) lookup
- **ML classifier**: NLP/CV model, probability score per category (NSFW, hate, spam)
- **Human review**: priority queue by severity; SLA-based routing

## Ad Tech Basics
| Concept | Description |
|---------|-------------|
| RTB (Real-Time Bidding) | Auction per impression, <100ms end-to-end |
| DSP | Demand-side platform; advertisers bid |
| SSP | Supply-side platform; publishers sell inventory |
| Second-price auction | Winner pays 2nd-highest bid + $0.01 |
| Targeting | Demographic, behavioral, contextual, lookalike |
| Frequency capping | Max N impressions per user per day (Redis INCR + TTL) |
| Click fraud | IP blacklist, bot detection, invalid traffic filters |

## Decision Guide
| Problem | Approach |
|---------|----------|
| Netflix/Spotify recs | Two-tower + collaborative filtering + feature store |
| New platform (cold start) | Content-based → hybrid as data grows |
| Fraud detection | Rule engine + gradient boosting + human review |
| Content moderation | Hash matching + ML classifier + human queue |
| Ad serving | RTB auction + frequency cap + targeting pipeline |
| Search ranking | Learning-to-rank (LambdaMART) + query embeddings |
