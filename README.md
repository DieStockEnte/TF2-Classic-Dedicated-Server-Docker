# TF2 Classic dedicated server with Docker compose
With this docker compose you can create customizable dedicated servers for Team Fortress 2 Classic.
This might only work on Linux operating systems and not on Windows.
This Docker compose needs approximately 7GB of disk space.

## Building and running
**1.** Install Docker and Docker-Compose.<br />
**2.** Download all files from this repository and put them in a folder.<br />
**3.** Go with your CMD into the folder and run the following commands:<br />
```
docker-compose build
docker-compose up -d
```
**And your done!** You should now be able to connect to your tf2c server.
If you are not able to connect to the server, then check if the ports `27015/udp` and `27015/tpc` are open.

### With the following commands you can do some actions with the server:
#### See if a container is existing and running:
```
docker ps
```
#### Stop the server:
```
docker-compose stop
```
#### Enter into the docker containers CMD, for example to see logs:
`<container-id>` Insert here the id of the container or if it works just `tf`. Leave the `<>` signs away.
```
docker exec -it <container-id> bash
```
If you want to leave the Docker containers CMD press `ctrl` + `c`.

## Settings:
### Add plugins to the server:
To add plugins to the server, go under `addons/sourcemod/plugins` and add there the plugin file.

### Change the tf2 server settings:
You can change settings inside `cfg/server.cfg`

### Change the motd when entering the server:
You can change the motd inside `cfg/motd.txt`. Inside this file can be plain text or HTML code.

### See live console output of the server:
```
docker-compose up
```

### Add a map:
Insert you map into the `maps/` folder and then go inside `cfg/mapcycle.txt` and write the filename without the file ending. For every map use a seperate line. For example:
```
koth_hangar_rc5
ctf_2fort
pl_test_map_a1
```
If you delete `plr_crossbone.bsp` then you also need to set the map (wich the server selects on startup. tf2c, unlike tf2, can't start the server with a random map) in the `runserver.sh`. Change the map name (without file extension) after +map. For Example:
```
./srcds_run -console -game tf2classic -autoupdate -steam_dir /opt/tf2classic/steamcmd/ -steamcmd_script /opt/tf2classic/tf2classic.txt +map ctf_4fort -ip 0.0.0.0 -strictportbind
```

### Add bots:
To add bots add these lines to the config file `cfg/server.cfg`:
```
tf_bot_quota 24
tf_bot_quota_mode "fill"
tf_bot_auto_vacate 1
```

## Question/Answers:
### Q: Why does it take so long to set up?
**A:** It takes so long because a lot is happening. The command `docker-compose build` can take up to 20 minutes. With a bad internet connection up to 45 minutes. But afterwards it takes just 1 minute when executing the command again.

### Q: I changed the map and restarted the server. Why can't I see the changes?
**A:** For every change (for example adding/removing maps, changing the `server.cfg` settings) you need to build the image (on which the server runs) again. Just run these two commands:
```
docker-compose build
docker-compose up -d
```
Note: You need to stop the server first with this command: `docker-compose stop`
### Q: The data, which the sourcemod plugins store get deleted after executing `docker-compose build`. Why and how can I prevent this?
**A:** This happens because everytime you type this command the server gets deleted and recreated. You can't really prevent this, but you can make an outside connection to your main operating system by connecting the database file with (for example .sql) a database file on the main operating system. You find more information in the `docker-compose.yml` file.

## Final part:
You can use, change, share and modify the files from this repository.<br />
I do not own and did not created the map `plr_crossbone.bsp`.<br />
If you have any questions or want to contribute to this repository feel free to do so by opening an issue in the issues tab!<br />
Have fun with this little project! 😜
