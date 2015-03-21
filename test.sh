export $(grep "^[^#]*=.*" ".env" | xargs)
./bin/hubot
