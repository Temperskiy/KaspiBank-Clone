package com.kaspi.clone

import android.nfc.cardemulation.HostApduService
import android.os.Bundle

class KaspiHCEService : HostApduService() {
    
    companion object {
        var transferData: String = ""
        var isReady: Boolean = false
    }
    
    override fun processCommandApdu(commandApdu: ByteArray, extras: Bundle?): ByteArray {
        if (commandApdu.size >= 4) {
            val response = transferData.toByteArray()
            isReady = false
            return response
        }
        return byteArrayOf(0x6A.toByte(), 0x82.toByte())
    }
    
    override fun onDeactivated(reason: Int) {
        isReady = false
    }
}
