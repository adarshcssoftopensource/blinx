package BlinxAutomation;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.testng.Assert;

import io.appium.java_client.TouchAction;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.touch.LongPressOptions;
import io.appium.java_client.touch.offset.ElementOption;

public class Login {

	public static void main(String[] args) throws MalformedURLException, InterruptedException {

	    DesiredCapabilities dc = new DesiredCapabilities();
	    dc.setCapability("automationName", "UiAutomator2");
	    dc.setCapability("platformName", "Android");
	    dc.setCapability("deviceName", "R5CR20GWTXM"); 
	    dc.setCapability("udid", "R5CR20GWTXM");
	    dc.setCapability("appPackage", "com.civicfind.blinx.blinx_mobile");
	    dc.setCapability("appActivity", "com.civicfind.blinx.blinx_mobile.MainActivity");
	    dc.setCapability("newCommandTimeout", 600);
	    
	    AndroidDriver driver = new AndroidDriver(
	            new URL("http://127.0.0.1:4723/wd/hub"),
	            dc
	    );        //appuim 1x 
	    

	     Thread.sleep(3000);
	     driver.findElement(By.xpath("//android.widget.Button[@content-desc=\"Skip\"]")).click();
	     Thread.sleep(3000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[1]")).click();
	     Thread.sleep(3000);  // reduce unnecessary wait
	     driver.findElement(By.xpath("(//android.widget.EditText)[1]")).clear();  // add this
	     Thread.sleep(3000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[1]")).sendKeys("chris@yopmail.com");
	     Thread.sleep(3000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[2]")).click();
	     Thread.sleep(3000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[2]")).clear();  // add this
	     Thread.sleep(3000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[2]")).sendKeys("Password@123");
	     Thread.sleep(5000);
	    
	         try {
	         driver.hideKeyboard();
	     } catch (Exception e) {
	         System.out.println("Keyboard already hidden");
	     }
	         WebElement signInBtn = driver.findElement(
	                 By.xpath("//android.widget.Button[@content-desc='Sign In']")
	         );
			 Thread.sleep(5000);
	         signInBtn.click();
		Assert.assertTrue(false, "Intentional failure for CI testing");
		Assert.assertTrue(true, "Intentional failure for CI testing");
		
	         
            		
//            		Thread.sleep(3000);
//            		driver.findElement(By.xpath(
//            				"//android.view.View[@content-desc='codex Verified 1d ago · Mountain View, United States Code-Zone #Infrastructure']/android.widget.ImageView[1]"
//            				)).click();  // open the post 	
            		
            		
            		     		
	}

}
