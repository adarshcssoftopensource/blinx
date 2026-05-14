package BlinxAutomation;

import java.net.MalformedURLException;
import java.net.URL;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;

import io.appium.java_client.android.AndroidDriver;

public class SignUp {

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
	    
	    
	    driver.findElement(By.xpath("//android.widget.Button[@content-desc=\"Skip\"]")).click();
	    driver.findElementByAccessibilityId("Sign Up").click();
	    Thread.sleep(2000);
	    WebElement usernameField = driver.findElement(By.xpath("//android.widget.EditText[1]"));
	    usernameField.click();
	    usernameField.clear();
	    usernameField.sendKeys("testuserone");
	    Thread.sleep(1000);
	    // 3) Email
	    WebElement emailField = driver.findElement(By.xpath("//android.widget.EditText[2]"));
	    emailField.click();
	    emailField.clear();
	    emailField.sendKeys("testuserone@yopmail.com");
	    Thread.sleep(1000);
	    // 4) Password
	    WebElement passwordField = driver.findElement(By.xpath("//android.widget.EditText[3]"));
	    passwordField.click();
	    passwordField.clear();
	    passwordField.sendKeys("Testcs@123");
	    
       try {
       driver.hideKeyboard();
   } catch (Exception e) {
       System.out.println("Keyboard already hidden");
   }
	    driver.findElementByAccessibilityId("Sign Up").click();
	}

}
