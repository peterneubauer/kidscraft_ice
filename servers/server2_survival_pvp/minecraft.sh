#!/bin/sh
# Controls the minecraft server

#####################
#START CONFIGURATION#
#####################

# Replace the location path with the folder containing your CraftBukkit.jar or minecraft_server.jar file
LOCATION="/home/kidscraft/kidscraft/kidscraft_ice/servers/server2_creative_plots"

#Replace CraftBukkit with the name of the .jar file you use
MINECRAFT="craftbukkit.jar"

# Path to your java executable (or just "java" if it's already in your $PATH)
JAVA="java"

#Java Options - Replace with options that are sane and stable for your server
JAVAOPTS="-Xmx2g -server -jar"

SCRNAME="ice2"

###################
#END CONFIGURATION#
###################

#Determine whether or not Minecraft is already running
RUNNING=`screen -ls | grep minecraft`

case "$1" in
'start')
        cd $LOCATION
        RUNNING=`screen -ls | grep $SCRNAME`
        if [ "$RUNNING" = "" ]
        then
                screen -dmS $SCRNAME $JAVA $JAVAOPTS $MINECRAFT -o true nogui
        fi
        ;;
'stop')
        screen -x $SCRNAME -X stuff "`printf "kickall Restarting server!  Try again in 60 seconds!\r"`"
        sleep 2
        screen -x $SCRNAME -X stuff `printf "stop\r"`
        ;;

'restart')
        screen -x $SCRNAME -X stuff "`printf "kickall Restarting server!  Try again in 60 seconds!\r"`"
        sleep 2
        screen -x $SCRNAME -X stuff `printf "stop\r"`
        RUNNING=`screen -ls | grep $SCRNAME`
        cd $LOCATION
        until [ "$RUNNING" = "" ]
        do
                RUNNING=`screen -ls | grep $SCRNAME`
        done
        screen -dmS $SCRNAME $JAVA $JAVAOPTS $MINECRAFT nogui
        sleep 1
        screen -x $SCRNAME
        ;;

'view')
        screen -x $SCRNAME
        ;;

'sv')
        cd $LOCATION
        if [ "$RUNNING" = "" ]
        then
                screen -dmS $SCRNAME $JAVA $JAVAOPTS $MINECRAFT nogui
        fi
        sleep 1
        screen -x $SCRNAME
        ;;

*)
        echo "Usage: $0 { start | stop | restart | view | sv (start & view) }"
        ;;
esac
exit 0
