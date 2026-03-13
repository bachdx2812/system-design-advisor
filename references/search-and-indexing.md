# Search & Indexing Systems

## Inverted Index
- Map: term → list of document IDs (posting list)
- Tokenization: split text → lowercase → stem → remove stop words
- Storage: term dictionary (B-tree/hash) + posting lists (sorted doc IDs)
- Compression: delta encoding + variable-byte encoding for posting lists

## Relevance Scoring
- **TF-IDF:** term frequency x inverse document frequency (classic)
- **BM25:** Improved TF-IDF with saturation + document length normalization (Elasticsearch default)
- **PageRank:** Link graph authority (web search)
- Combine: BM25 for text relevance + signals (recency, popularity, personalization)

## Elasticsearch Architecture
- **Index:** Split into shards (each is a Lucene index)
- **Shard:** Primary + replicas; search runs on all shards, merge results
- **Near real-time:** Refresh interval (1s default) — new docs visible after refresh
- **Segment merging:** Background merge of immutable segments (like LSM compaction)
- Scale reads: add replicas. Scale writes: add shards (cannot reshard easily — plan ahead)

## Search Autocomplete / Typeahead
- **Trie (prefix tree):** O(L) lookup where L=prefix length; store frequency at nodes
- **Top-K:** Each trie node stores top-K completions (precomputed)
- **Redis approach:** Sorted set per prefix (`auto:he` → ZADD with frequency score)
- **Ranking:** frequency x recency x personalization weight
- **Client:** Debounce 200-300ms, only query after 2+ characters
- **Caching:** Cache top queries in CDN/browser; long-tail queries hit backend

## Full-Text Search Pipeline
```
Ingest → Tokenize → Analyze (stem, synonyms) → Index (inverted) → Store
Query → Parse → Expand (synonyms) → Score (BM25) → Rank → Return
```

## Faceted Search
- Pre-compute aggregation counts per facet (category: 5, color: 3)
- Use doc value fields (columnar storage alongside inverted index)

## Search System Scaling
- Scatter-gather: query all shards → merge top-K results
- Tiered index: hot (SSD) / warm (HDD) / cold (S3)
- Query cache: hash(query) → results for frequent queries

## Web Crawler
- **URL Frontier:** Priority queue (importance) + politeness queue (per-host rate limit)
- **Deduplication:** URL fingerprint (MD5/SHA) + content fingerprint (SimHash)
- **robots.txt:** Respect crawl-delay, disallow paths
- **DNS cache:** Avoid per-URL DNS lookup (cache locally)
- **Distributed:** Consistent hashing to assign URL ranges to crawler nodes
- **Politeness:** Max 1 req/s per domain; exponential backoff on errors
