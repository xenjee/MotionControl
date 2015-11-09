//
//  ChannelCellView.swift
//  MotionControl
//
//  Created by Alan Westbrook on 7/17/15.
//  Copyright (c) 2015 slartibartfist. All rights reserved.
//

import Cocoa

class ChannelCellView: NSTableCellView {
    
    // ------ LIVE STUFF -------- //
    
    @IBOutlet weak var channelActualPositionSlider: NSSlider!
    @IBOutlet weak var channelActualPositionReadout: NSTextField!
    @IBOutlet weak var channelDesiredPositionSlider: NSSlider!
    @IBOutlet weak var channelDesiredPositionReadout: NSTextField!

    @IBOutlet weak var speedGraph: NSProgressIndicator!
    @IBOutlet weak var homedIndicator: NSButton!
    
    @IBOutlet weak var trkIndicatorLeft: NSImageView!
    @IBOutlet weak var trkIndicatorRight: NSImageView!

    
    // ------ PERSISTENT STUFF -------- //

    
    @IBOutlet weak var channelNameField: NSTextField!
    @IBOutlet weak var channelUnitsActualText: NSTextField!
    @IBOutlet weak var channelUnitsDesiredText: NSTextField!


    // ------ SETTINGS -------- //
    
    
    @IBOutlet weak var speedSlider: NSSlider!
    @IBOutlet weak var accelSlider: NSSlider!
    @IBOutlet weak var speedSliderReadout: NSTextField!
    @IBOutlet weak var accelSliderReadout: NSTextField!
    
    //@IBOutlet weak var channelDesiredPositionSliderCell: NSSliderCell!
    
    @IBOutlet weak var motorEnabledSwitch: NSButton!
   
    @IBAction func nudgePositive(sender: NSButton) {
    
//            if let targetData = objectValue as? Channel {
//                targetData.positionDesired += targetData.positionNudgeSmall
//                
//        }
    }
   
    
    @IBAction func nudgeNegative(sender: NSButton) {
        
//        if let targetData = objectValue as? Channel {
//            targetData.positionDesired -= targetData.positionNudgeSmall
//            
//        }
    }
    
    var oldPositionActual = 999990.0
    var oldPositionDesired = 9999990.0
    var oldVelocity = 999999990.0
    var oldChannelState = ChannelState.Uninitialised
    
    let mytrkIndicatorONImage = NSImage(named: "trkIndicatorOnGreen")
    let mytrkIndicatorOFFImage = NSImage(named: "trkIndicatorOFFGreen")
    
    func updateLiveValues() {
        if let value = objectValue as? ChannelUI {
            
            if value.channelDataLive.channelState != oldChannelState {
                oldChannelState = value.channelDataLive.channelState
                
                switch oldChannelState {
                case .HandControl:
                    motorEnabledSwitch.state = NSOffState
                    motorEnabledSwitch.title = "MANUAL"
                    channelDesiredPositionSlider.enabled = false
                default:
                    motorEnabledSwitch.state = NSOnState
                    motorEnabledSwitch.title = "MOTOR ON"
                    channelDesiredPositionSlider.enabled = true
                }
                motorEnabledSwitch.setNeedsDisplay()
                channelDesiredPositionSlider.setNeedsDisplay()
            }

            if value.channelDataLive.positionActual != oldPositionActual {
                channelActualPositionSlider.doubleValue = value.channelDataLive.positionActual
                channelActualPositionSlider.setNeedsDisplay()
                channelActualPositionReadout.integerValue = Int(value.channelDataLive.positionActual)
                channelActualPositionReadout.setNeedsDisplay()
                oldPositionActual = value.channelDataLive.positionActual
            }
            
        if value.channelDataLive.positionDesired != oldPositionDesired {
            channelDesiredPositionSlider.doubleValue = value.channelDataLive.positionDesired
            channelDesiredPositionSlider.setNeedsDisplay()
            channelDesiredPositionReadout.integerValue = Int(value.channelDataLive.positionDesired)
            oldPositionDesired = value.channelDataLive.positionDesired
        }
        
            if value.channelDataLive.velocityCurrent != oldVelocity {
//                
                     speedGraph.doubleValue = 100.0 * (abs(value.channelDataLive.velocityCurrent) / (value.channelDataPersistent.maximumSpeed))
//                //speedGraph.setNeedsDisplay()
//            
                trkIndicatorLeft.image = (value.channelDataLive.velocityCurrent >= 0.0 ) ? mytrkIndicatorOFFImage : mytrkIndicatorONImage
//                trkIndicatorLeft.setNeedsDisplay()
                trkIndicatorRight.image = (value.channelDataLive.velocityCurrent <= 0.0 ) ? mytrkIndicatorOFFImage : mytrkIndicatorONImage
//                trkIndicatorRight.setNeedsDisplay()
//            
                oldVelocity = value.channelDataLive.velocityCurrent
            }
            let sensorState = (value.channelDataLive.homeSensorClosed) ? NSOnState : NSOffState
            if (homedIndicator.state != sensorState) {
                Swift.print ("HomeChanged")
                homedIndicator.state = sensorState
                homedIndicator.setNeedsDisplay()
            }
//
        }
    }
    
    override var objectValue:AnyObject? {
        didSet {
            if let theChannel = objectValue as? ChannelUI {
                // assign value.property to UI elements 
                channelNameField.stringValue = theChannel.channelDataPersistent.channelName
                
                channelActualPositionSlider.maxValue = theChannel.channelDataPersistent.positionMaximum
                channelActualPositionSlider.minValue = theChannel.channelDataPersistent.positionMinimum
                channelDesiredPositionSlider.maxValue = theChannel.channelDataPersistent.positionMaximum
                channelDesiredPositionSlider.minValue = theChannel.channelDataPersistent.positionMinimum
                
//                channelActualPositionSlider.doubleValue = theChannel.channelDataLive.positionActual
//                channelDesiredPositionSlider.doubleValue = theChannel.channelDataLive.positionDesired
                
                channelUnitsActualText.stringValue = theChannel.channelDataPersistent.displayUnits
                channelUnitsDesiredText.stringValue = theChannel.channelDataPersistent.displayUnits
                
//                channelActualPositionReadout.stringValue = NSString(format: "%.2f", theChannel.channelDataLive.positionActual) as String
//                channelDesiredPositionReadout.stringValue = NSString(format: "%.2f", theChannel.channelDataLive.positionDesired) as String
                
//                motorEnabledSwitch.state = (theChannel.channelDataLive.channelState != .HandControl) ? NSOffState : NSOnState
                
                homedIndicator.state = (theChannel.channelDataLive.homeSensorClosed) ? NSOnState : NSOffState
                //homedIndicator.
                
                   // setup stuff
                
                speedSlider.maxValue = theChannel.channelDataPersistent.maximumSpeed
                accelSlider.maxValue = theChannel.channelDataPersistent.maximumAcceleration
                
                speedSlider.doubleValue = theChannel.channelDataSettings.maximumSpeed
                accelSlider.doubleValue = theChannel.channelDataSettings.maximumAcceleration
                
                speedSliderReadout.stringValue = NSString(format: "%.2f", theChannel.channelDataSettings.maximumSpeed) as String
                accelSliderReadout.stringValue = NSString(format: "%.2f", theChannel.channelDataSettings.maximumAcceleration) as String
                updateLiveValues()
            }
        }
    }

    
    
    @IBAction func quickJumpButton(sender: NSButton) {
        if let targetData = objectValue as? ChannelUI {
            var newPos = 0.0
            switch (sender.tag) {
            case 0:
                newPos = channelDesiredPositionSlider.minValue
                break
            case 1:
                newPos = channelDesiredPositionSlider.minValue + (0.25 * (channelDesiredPositionSlider.maxValue - channelDesiredPositionSlider.minValue))
                break
            case 2:
                newPos = channelDesiredPositionSlider.minValue + (0.5 * (channelDesiredPositionSlider.maxValue - channelDesiredPositionSlider.minValue))
                break
            case 3:
                newPos = channelDesiredPositionSlider.minValue + (0.75 * (channelDesiredPositionSlider.maxValue - channelDesiredPositionSlider.minValue))
                break
            case 4:
                newPos = channelDesiredPositionSlider.maxValue
                break
            default:
                break
            }
            if channelDesiredPositionSlider.enabled {
                targetData.channelHandler.channelDesiredPositionMove(targetData.channelDataPersistent.channelInterfaceID, newValue: newPos)
            }
        }
        
    }
    
    
    @IBAction func channelDesiredPositionSliderMoved(sender: NSSlider) {
          let theValue = sender.doubleValue
        if let targetData = objectValue as? ChannelUI {
            targetData.channelHandler.channelDesiredPositionMove(targetData.channelDataPersistent.channelInterfaceID, newValue: theValue)
            channelDesiredPositionReadout.stringValue = NSString(format: "%.2f", theValue) as String
        }
    }


    @IBAction func motorEnabledSwitch(sender: NSButton) {
        if let channel = objectValue as? ChannelUI {
            if sender.state == NSOnState {
                sender.title = "MOTOR ON"
            } else {
                sender.title = "MANUAL"
            }
            channel.channelHandler.channelMotorEnable(channel.channelDataPersistent.channelInterfaceID, enable: (sender.state == NSOnState))
        }
    }

    
    
    @IBAction func speedOrAccelSliderMoved(sender: NSSlider) {
      
        if let targetData = objectValue as? ChannelUI {
            targetData.channelHandler.settingsChange(targetData.channelDataPersistent.channelInterfaceID, mSpeed: speedSlider.doubleValue, mAccel: accelSlider.doubleValue)
                    speedSliderReadout.stringValue = NSString(format: "%.2f", speedSlider.doubleValue) as String
            accelSliderReadout.stringValue = NSString(format: "%.2f", accelSlider.doubleValue) as String
        }
        
    }
    
    
    @IBAction func accelSliderMoved(sender: NSSlider) {
        let theValue = sender.doubleValue
//        if let targetData = objectValue as? Channel {
//            targetData.maximumAcceleration = theValue
//            accelSliderReadout.stringValue = NSString(format: "%.2f", theValue) as String
//        }

    }
    
    
    @IBAction func homeButtonPressed(sender: NSButton) {
        if let chan = objectValue as? ChannelUI {
            chan.channelHandler.homeOneChannel(chan.channelDataPersistent.channelInterfaceID)
        }
    }
    
    
    
   }
