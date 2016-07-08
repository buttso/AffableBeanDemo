/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package message;

import entity.CustomerOrder;
import entity.Delivery;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.ObjectMessage;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author sbutton
 */
@MessageDriven(
        mappedName = "jms/DeliveryQueue",
        activationConfig = {
            @ActivationConfigProperty(
                    propertyName = "destinationType", propertyValue = "javax.jms.Queue")
//                ,
//            @ActivationConfigProperty(
//                    propertyName = "destinationLookup", propertyValue = "jms/DeliveryQueue")

        })
public class DeliveryRequestHandler implements MessageListener {

    @PersistenceContext(unitName = "AffableBeanPU")
    private EntityManager em;

    public DeliveryRequestHandler() {
    }

    @Override
    public void onMessage(Message message) {
        try {
            ObjectMessage om = (ObjectMessage) message;
            CustomerOrder customerOrder = (CustomerOrder) om.getObject();
//            System.out.printf("Delivery Request: %s %s\n",
//                    customerOrder.getCustomer().getName(),
//                    customerOrder.getCustomer().getAddress());
            Delivery delivery = new Delivery();
            delivery.setName(customerOrder.getCustomer().getName());
            delivery.setAddress(customerOrder.getCustomer().getAddress());
            delivery.setOrderPlaced(customerOrder.getDateCreated());
            em.persist(delivery);
        } catch (JMSException ex) {
            Logger.getLogger(DeliveryRequestHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
