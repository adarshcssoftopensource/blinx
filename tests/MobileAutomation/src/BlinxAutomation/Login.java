package BlinxAutomation;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

import org.openqa.selenium.By;
import org.openqa.selenium.remote.DesiredCapabilities;

import io.appium.java_client.android.AndroidDriver;

public class Login {

	public static void main(String[] args) throws InterruptedException, MalformedURLException {
		
		
		
		DesiredCapabilities dc = new DesiredCapabilities();

	    dc.setCapability("appium:automationName", "UiAutomator2");
	    dc.setCapability("appium:platformName", "Android");
	    dc.setCapability("appium:udid", "R5CR20GWTXM"); // better than deviceName
	    dc.setCapability("appium:appPackage", "com.civicfind.blinx.blinx_mobile");
	    dc.setCapability("appium:appActivity", "com.civicfind.blinx.blinx_mobile.MainActivity");

	    AndroidDriver driver = new AndroidDriver(
	            new URL("http://127.0.0.1:4723/wd/hub"), dc);        //appuim 1x 
	    
//	    driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(20));
        Thread.sleep(20000);  // better than implicit wait for this case
	    driver.findElement(By.xpath("//android.widget.Button[@content-desc='Skip']")).click();
	    Thread.sleep(5000);
	    // Email
	    driver.findElement(By.xpath("(//android.widget.EditText)[1]")).click();
	    Thread.sleep(2000);  // reduce unnecessary wait
	    driver.findElement(By.xpath("(//android.widget.EditText)[1]")).clear();  // add this
	    driver.findElement(By.xpath("(//android.widget.EditText)[1]")).sendKeys("chris@yopmail.com");

	    Thread.sleep(5000);

	    // Password
	    driver.findElement(By.xpath("(//android.widget.EditText)[2]")).click();
	    Thread.sleep(2000);
	    driver.findElement(By.xpath("(//android.widget.EditText)[2]")).clear();  // add this
	    driver.findElement(By.xpath("(//android.widget.EditText)[2]")).sendKeys("Password@123");
	    Thread.sleep(5000);

	    // Hide keyboard (important)
	    try {
	        driver.hideKeyboard();
	    } catch (Exception e) {
	        System.out.println("Keyboard already hidden");
	    }
	    Thread.sleep(3000);

	}


}


