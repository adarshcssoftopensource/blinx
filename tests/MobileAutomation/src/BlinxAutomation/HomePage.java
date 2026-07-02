package BlinxAutomation;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import io.appium.java_client.TouchAction;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.touch.LongPressOptions;
import io.appium.java_client.touch.offset.ElementOption;

public class HomePage {

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
		    );       		    		     
		    
		    WebDriverWait wait = new WebDriverWait(driver, 20);
	        Thread.sleep(25000);
	        By likeBtnXpath = By.xpath("(//android.view.View[@content-desc='0'])[1]");
	        WebElement likeBtn = wait.until(ExpectedConditions.elementToBeClickable(likeBtnXpath));
	        likeBtn.click();
	        
	     // COMMENT BUTTON
	        WebElement cmtBtn = wait.until(ExpectedConditions.elementToBeClickable(likeBtnXpath));
	        cmtBtn.click();
            Thread.sleep(2500);
            WebElement textField = driver.findElement(By.xpath(
           	"/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.EditText"));
           	textField.click();
           	textField.sendKeys("hello GD");     	// add comment 	
           	driver.findElement(By.xpath("/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget."+ "FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android."+ "view.View/android.view.View/android.view.View[8]"))
           	.click();
           	WebElement comment = driver.findElement(By.xpath(                      // long press
           	"//android.view.View[contains(@content-desc,'hello GD')]"));

        	TouchAction action = new TouchAction(driver);
            action.longPress(LongPressOptions.longPressOptions()    // long press delete button 
            .withElement(ElementOption.element(comment))
           .withDuration(Duration.ofSeconds(2))).release().perform();   		
           
              WebElement popup = driver.findElement(By.xpath("/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.view.View"));
           
              if (popup.isDisplayed()) {
               System.out.println("PASS : Delete popup opened");
              } else {
               System.out.println("FAIL : Delete popup not opened");
               }
             // CLICK DELETE
                driver.findElement(By.xpath(
           		"//android.widget.Button[@content-desc='Delete']")).click();
               List<WebElement> noCommentMsg = driver.findElements(By.xpath("//android.view.View[@content-desc='No comments yet. Be the first!']"));
           		if(noCommentMsg.size() > 0) {
           		   System.out.println("PASS : Comment deleted successfully");
           		} else {
           		   System.out.println("FAIL : Comment not deleted");
           		}
           		Thread.sleep(3000);
          		driver.findElement(By.xpath(
          		"/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]/android.widget.ImageView"))
         		.click(); // for back button 
         		
	}

}


