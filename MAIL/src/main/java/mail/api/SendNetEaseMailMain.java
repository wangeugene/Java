package mail.api;

import mail.api.configuration.MailClientConfiguration;
import mail.api.configuration.NetEaseMailClientConfiguration;
import mail.api.sender.SimpleMailSender;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Created by IntelliJ IDEA.<br/>
 * User: eugene<br/>
 * Date: 2018/12/27<br/>
 * Time: 17:50<br/>
 * To change this template use File | Settings | File Templates.
 * it's not working
 */
public class SendNetEaseMailMain {
    private static final Logger logger = LoggerFactory.getLogger(SendNetEaseMailMain.class);

    public static void main(String[] args) {
        MailClientConfiguration neteaseMailConf = new NetEaseMailClientConfiguration();
        neteaseMailConf.setSubject("Eugene Subject");
        neteaseMailConf.setContent("这是一个中文测试邮件,下午开会");
        neteaseMailConf.setToAddress("sail456852@hotmail.com");
        neteaseMailConf.setFromAddress("sail456852@163.com");
        neteaseMailConf.setUsername("sail456852@163.com");
//        neteaseMailConf.setPassword("ULCGHESWKRJQMVWG");
        boolean b = SimpleMailSender.sendSimpleEmail(neteaseMailConf);
        if (b) {
            logger.info("Mail Send Okay");
        } else {
            logger.info("b={}", "Mail Send Failure");
        }
    }
}
