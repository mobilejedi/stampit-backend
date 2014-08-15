package com.stampit.model;

// Generated 1-ago-2014 11.47.35 by Hibernate Tools 3.4.0.CR1

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.springframework.data.rest.core.annotation.RestResource;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * CustomerFeedbacks generated by hbm2java
 */
@Entity
@Table(name = "CUSTOMER_FEEDBACKS", catalog = "STAMPIT")
public class CustomerFeedback implements java.io.Serializable {

	private long idFeedback;
	private Customer customer;
	private String message;
	private Date insDate;

	public CustomerFeedback() {
	}

	@Id
	@Column(name = "ID_FEEDBACK", unique = true, nullable = false)
	public long getIdFeedback() {
		return this.idFeedback;
	}

	public void setIdFeedback(long idFeedback) {
		this.idFeedback = idFeedback;
	}	
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ID_CUSTOMER", nullable = false)		
	public Customer getCustomer() {
		return this.customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	@Column(name = "MESSAGE", nullable = false, length = 1000)
	public String getMessage() {
		return this.message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "INS_DATE", nullable = false, length = 19)
	public Date getInsDate() {
		return this.insDate;
	}

	public void setInsDate(Date insDate) {
		this.insDate = insDate;
	}

}
