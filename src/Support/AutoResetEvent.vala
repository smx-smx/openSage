namespace OpenSage.Support {

public class AutoResetEvent {
	private ManualResetEvent ev;
	
	public AutoResetEvent(bool signaled = false){
		ev = new ManualResetEvent(signaled);
	}
	
	public void set(){
		ev.set();
	}
	
	public void wait(){
		ev.wait();
		ev.unset();
	}
}

}
