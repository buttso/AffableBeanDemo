/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package session;

import entity.CustomerOrder;
import javax.annotation.Resource;
import javax.ejb.Stateless;
import javax.jms.JMSException;
import javax.jms.ObjectMessage;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueSender;
import javax.jms.QueueSession;

/**
 *
 * @author sbutton
 */
@Stateless
public class DeliveryManager {
    
    @Resource(lookup = "jms/DeliveryCF")
    private QueueConnectionFactory connectionFactory;

    @Resource(lookup = "jms/DeliveryQueue")
    private Queue queue;

    public void submitDeliveryAdvice(CustomerOrder customerOrder) throws JMSException {
//        System.out.println(Thread.currentThread().getStackTrace()[1].getMethodName());

        QueueConnection qconnection = null;
        QueueSession qsession = null;
        QueueSender qsender = null;

        try {
            qconnection = connectionFactory.createQueueConnection();
            qsession = qconnection.createQueueSession(true, 0);
            qsender = qsession.createSender(queue);
            ObjectMessage message = qsession.createObjectMessage(customerOrder);
            qsender.send(message);
        } catch (JMSException jmse) {
            jmse.printStackTrace();
            throw jmse;
        } finally {
            if (qsender != null) {
                qsender.close();
            }
            if (qsession != null) {
                qsession.close();
            }
            if (qconnection != null) {
                qconnection.close();
            }
        }
    }
}
