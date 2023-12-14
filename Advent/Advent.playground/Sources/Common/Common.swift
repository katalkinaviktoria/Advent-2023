import Foundation

public func reportMemory() {
	var taskInfo = task_vm_info_data_t()
	var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
	let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
		$0.withMemoryRebound(to: integer_t.self, capacity: 1) {
			task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
		}
	}
	let usedMb = Float(taskInfo.phys_footprint) / 1048576.0
	let totalMb = Float(ProcessInfo.processInfo.physicalMemory) / 1048576.0
	result != KERN_SUCCESS ? print("Memory used: ? of \(totalMb) Mb") : print("Memory used: \(usedMb) Mb of \(totalMb) Mb")
}

public func measureTime(_ operation: () -> Void) {
	let startTime = DispatchTime.now()
	operation()
	let endTime = DispatchTime.now()

	let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
	let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0

	print("Execution time: \(elapsedTimeInMilliSeconds) ms")
}

public func measureAverageTime(timesToRun: Int = 10, _ operation: () -> Void) {
	var times = [UInt64]()
	for _ in 0 ..< timesToRun {
		let time = measureElapsedTime(operation)
		times.append(time)
	}
	let measureAverageTime = times.reduce(0, +) / UInt64(times.count)
	print("Average time: \(measureAverageTime) ms")
}

func measureElapsedTime(_ operation: () -> Void) -> UInt64 {
	let startTime = DispatchTime.now()
	operation()
	let endTime = DispatchTime.now()

	let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
	let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0

	return UInt64(elapsedTimeInMilliSeconds)
}

