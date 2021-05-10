#!/usr/bin/env python3

import mission_execution_control as mxc

import rospy

def mission():
  print("Starting mission...")

  print("TAKE_OFF...")
  mxc.executeTask('TAKE_OFF')

  print("ROTATE...")
  mxc.executeTask('ROTATE', relative_angle = 270)	

  print("FOLLOW_PATH...")
  mxc.executeTask('FOLLOW_PATH', path = [ [0, 2, 1], [2, 2, 1], [2, 0, 1], [0, 0, 1] ])	

  print('Mission completed.')