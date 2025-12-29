#! /bin/bash
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
uv run flask --app ./api run --debug --host=0.0.0.0 --port=8004