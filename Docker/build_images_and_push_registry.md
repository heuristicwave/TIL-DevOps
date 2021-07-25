## Build docker images and push private registry

Tutorial Repo : [node-app](https://gitlab.com/nanuchi/node-app), [java-app](https://gitlab.com/nanuchi/java-app)



1. Clone tutorial repo

2. Build docker images

3. Push private docker registry

   1. **Create Private Docker Registry**

   2. **Push Docker Images**

      ```shell
      $ docker login
      
      # Create Image Tag
      $ docker tag java-app:latest heuristicwave/demo-app:java-1.0
      
      # Check Docker Images
      $ docker images | grep app
      
      # Push Images
      $ docker push heuristicwave/demo-app:java-1.0
      ```

