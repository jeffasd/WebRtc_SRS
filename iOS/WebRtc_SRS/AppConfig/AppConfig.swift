//
//  AppConfig.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

class AppConfig {
    
    static var checkNetWorkURLStr = "https://www.baidu.com/"
    
    static var publishWebURLStr = "https://ossrs.net/players/rtc_publisher.html?vhost=d.ossrs.net&server=d.ossrs.net&api=443&schema=https&stream=6765ghytg545"
    static var playWebURLStr = "https://ossrs.net/players/rtc_player.html?vhost=d.ossrs.net&server=d.ossrs.net&api=443&schema=https&stream=6765ghytg545"
    
    static var appName = "live"
    static var streamName = "6765ghytg545"
    
    /// Note that you need to bring/after the address if you do not want to bring / Please modify the SRS source code.
    static var publishLocalHostURLStr = "https://localhost:443/rtc/v1/publish/"
    static var playLocalHostURLStr = "https://localhost:443/rtc/v1/play/"
    static var localHostStreamURLStr = "webrtc://localhost/\(AppConfig.appName)/\(AppConfig.streamName)"
    
    /// Note that you need to bring/after the address if you do not want to bring / Please modify the SRS source code.
    static var publishRemoteURLStr = "https://d.ossrs.net:443/rtc/v1/publish/"
    static var playRemoteURLStr = "https://d.ossrs.net:443/rtc/v1/play/"
    
}
