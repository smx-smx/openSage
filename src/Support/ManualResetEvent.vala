namespace OpenSage.Support {

public class ManualResetEvent {
	private Mutex mutex = Mutex();
	private Cond cond = Cond();
	private bool signaled = false;
	
	public ManualResetEvent(bool signaled = false){
		this.signaled = signaled;
	}
	
	public void set(){
		mutex.lock();
		signaled = true;
		mutex.unlock();
		
		cond.broadcast();
	}
	
	public void unset(){
		mutex.lock();
		signaled = false;
		mutex.unlock();
	}
	
	public void wait(){
		mutex.lock();
		while(!signaled)
			cond.wait(mutex);

		mutex.unlock();
	}
}

}
