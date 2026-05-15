package BlinxAutomation;

import java.net.MalformedURLException;
import java.net.URL;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;
import io.appium.java_client.android.AndroidDriver;

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
	    
	    

	     Thread.sleep(1000);
	    driver.findElement(By.xpath("//android.widget.Button[@content-desc=\"Skip\"]")).click();
	     Thread.sleep(1000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[1]")).click();
	     Thread.sleep(2000);  // reduce unnecessary wait
	     driver.findElement(By.xpath("(//android.widget.EditText)[1]")).clear();  // add this
	     driver.findElement(By.xpath("(//android.widget.EditText)[1]")).sendKeys("chris@yopmail.com");
	     Thread.sleep(5000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[2]")).click();
	     Thread.sleep(2000);
	     driver.findElement(By.xpath("(//android.widget.EditText)[2]")).clear();  // add this
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
	        // signInBtn.click();

	         // home page first feed 
	         Thread.sleep(25000);
//	         WebElement likeBtn = driver.findElement(By.xpath("(//android.view.View[@content-desc='0'])[1]"));
//	         likeBtn.click();	
//	        Thread.sleep(2500);
	        
	        WebElement cmtBtn = driver.findElement(By.xpath("(//android.view.View[@content-desc='0'])[1]"));
	        cmtBtn.click();
            Thread.sleep(2500);
            
            WebElement textField = driver.findElement(By.xpath(
            		"/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.EditText"
            		));

            		textField.click();
            		textField.sendKeys("hello GD");
            		
            		driver.findElement(By.xpath(
            				"/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget."
            				+ "FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android."
            				+ "view.View/android.view.View/android.view.View[8]"))
            		.click();
            		
	}
}
