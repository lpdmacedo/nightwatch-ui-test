package stress.app

class StressController {
    def index() { 
		def start = System.currentTimeMillis()
		def size = Integer.parseInt(params.size)
		def wait = Integer.parseInt(params.wait)
		def cpu  = Integer.parseInt(params.cpu)
		
		println "CPU: $cpu WAIT: $wait SIZE: $size"
		
		def out = buildDummyOutput(size)
		consumeCpu(start, cpu)
		sleepRemainingTime(start, wait)
		
		render out.toString(	)
	}
	
	
	// CPU Burn method
	def consumeCpu(start, cpu) {
		def i = 1
		while(true) {
			if(!(i%100000)) {
				def remain = remainingTimeTo(start, cpu)
				println "Checking CPU: remains: $remain cpu:$cpu start:$start"
				if(!remain)
					break;
			}
			i++
		}
	}

	// Calculates remaining time to a given objectivc	
	def remainingTimeTo(start, time) {
		def now = System.currentTimeMillis();
		def diff = (start + time) - now
		println "now: $now start:$start diff: $diff"
		diff = diff > 0 ? diff : 0
	}
	
	// Builds a dummy output with random characters
	def buildDummyOutput(size) {
		StringBuffer buff = new StringBuffer();
		size /= 10
		size.times() {
			buff.append("V323456789")
		}
		buff.toString()
	}
	
	
	def sleepRemainingTime(start, time) {
		def toSleep;
		while(toSleep = remainingTimeTo(start, time)) {
			println "I've to sleep for $toSleep ms"
			Thread.sleep(toSleep)
		}
	}
}
