# Rules

Rules are source files. Generated YAML, Shadowrocket profiles, and Verge profiles should be produced from these inputs.

Line format for `*.domains`:

```text
# comments are ignored
example.com
example.net
```

Keep module ownership clear:

- `ai/`: AI products and model providers
- `game/`: gaming platforms and console services
- `github/`: GitHub and developer workflow routing
- `media/`: streaming media such as Netflix
- `china/`: direct domestic routing rules
- `custom/`: local overrides

