package com.stampit.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.Table;

@Entity
@Table(name = "CUSTOMERS_CONFIRMATIONS", catalog = "STAMPIT")
public class CustomerConfirmation {
	
	
	private Long idCustomer;
	private String confirmationKey;
	private boolean confirmed;
	
	@Id
    @Column(name="ID_CUSTOMER")
	public Long getIdCustomer() {
		return idCustomer;
	}
	public void setIdCustomer(Long idCustoemr) {
		this.idCustomer = idCustoemr;
	}
	
	@Column(name="CONFIRMATION_KEY")
	public String getConfirmationKey() {
		return confirmationKey;
	}
	public void setConfirmationKey(String confirmationKey) {
		this.confirmationKey = confirmationKey;
	}
	
	@Column(name="CONFIRMED")
	public boolean getConfirmed() {
		return confirmed;
	}
	public void setConfirmed(boolean confirmed) {
		this.confirmed = confirmed;
	}	
	
}
