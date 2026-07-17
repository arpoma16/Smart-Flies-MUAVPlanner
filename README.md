# Smart-Flies: A General porpouse Multi-UAV TSP-based Task Planner.
[Paper Preprint](https://arxiv.org/abs/2410.20849)

## run docker 
```
docker build -t muavgcs:planner .
```

## run docker
```
docker run --rm -it -p 8004:8080 muavgcs:planner
```

## 

  uv run python -m flask --app ./api run --host=0.0.0.0 --port=8004                                                                                                   
    uv run flask --app ./api run --host=0.0.0.0 --port=8004                                                                                                             