package gov.va.med.imaging.musedatasource.cache;

import java.time.ZonedDateTime;

import gov.va.med.imaging.exchange.business.MuseOpenSessionResults;

public class MuseOpenSession {
	private MuseOpenSessionResults results;
	private ZonedDateTime expiration;

	public MuseOpenSession(MuseOpenSessionResults results, ZonedDateTime expiration) {
		this.results = results;
		this.expiration = expiration;
	}

	public MuseOpenSessionResults getResults() {
		return results;
	}

	public void setResults(MuseOpenSessionResults results) {
		this.results = results;
	}

	public ZonedDateTime getExpiration() {
		return expiration;
	}

	public void setExpiration(ZonedDateTime expiration) {
		this.expiration = expiration;
	}

}