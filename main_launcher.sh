#!/bin/bash

NUMID_DRONE=107
export APPLICATION_PATH=${PWD}


#---------------------------------------------------------------------------------------------
# INTERNAL PROCESSES
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor simulator                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Simulator" --command "bash -c \"
roslaunch quadrotor_simulator_process quadrotor_simulator.launch --wait \
    robot_namespace:=drone$NUMID_DRONE \
    robot_config_path:=${APPLICATION_PATH}/configs/drone$NUMID_DRONE \
    rviz_config_path:=${APPLICATION_PATH}/configs/rviz_files;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Basic Behaviors                                                                             ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Basic Behaviors" --command "bash -c \"
roslaunch basic_quadrotor_behaviors basic_quadrotor_behaviors.launch --wait \
    namespace:=drone$NUMID_DRONE;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor Motion With PID Control                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Motion With PID Control" --command "bash -c \"
roslaunch quadrotor_motion_with_pid_control quadrotor_motion_with_pid_control.launch --wait \
    namespace:=drone$NUMID_DRONE \
    robot_config_path:=${APPLICATION_PATH}/configs/drone$NUMID_DRONE \
    uav_mass:=0.7;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Python Interpreter                                                                          ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Python Interpreter" --command "bash -c \"
roslaunch python_based_mission_interpreter_process python_based_mission_interpreter_process.launch --wait \
  drone_id_namespace:=drone$NUMID_DRONE \
  drone_id_int:=$NUMID_DRONE \
  mission_configuration_folder:=${APPLICATION_PATH}/configs/mission ;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Execution Viewer                                                                   ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior Execution Viewer" --command "bash -c \"
roslaunch behavior_execution_viewer behavior_execution_viewer.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE \
  catalog_path:=${APPLICATION_PATH}/configs/mission/behavior_catalog.yaml;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Belief Manager                                                                              ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief Manager" --command "bash -c \"
roslaunch belief_manager_process belief_manager_process.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE \
    drone_id:=$NUMID_DRONE \
    config_path:=${APPLICATION_PATH}/configs/mission;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Belief Updater                                                                              ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Common Belief Updater" --command "bash -c \"
roslaunch common_belief_updater_process common_belief_updater_process.launch --wait \
  drone_id_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE;
exec bash\""   \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Coordinator                                                                       ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior coordinator" --command "bash -c \" sleep 5;
roslaunch behavior_coordinator behavior_coordinator.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  catalog_path:=${APPLICATION_PATH}/configs/mission/behavior_catalog.yaml;
exec bash\"" &

#---------------------------------------------------------------------------------------------
# USER INTERFACE PROCESSES
#---------------------------------------------------------------------------------------------
gnome-terminal \
`#---------------------------------------------------------------------------------------------` \
`# Belief Memory Viewer                                                                        ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief memory Viewer" --command "bash -c \"
roslaunch belief_memory_viewer belief_memory_viewer.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Alphanumeric Viewer                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Alphanumeric Viewer"  --command "bash -c \"
roslaunch alphanumeric_viewer alphanumeric_viewer.launch  --wait \
    drone_id_namespace:=drone$NUMID_DRONE;
exec bash\""  &

sleep 10

gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Coordinator Loggr                                                                       ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "behavior_coordinator_logger"  --command "bash -c \"
roslaunch behavior_coordinator_logger behavior_coordinator_logger.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE;
exec bash\""
