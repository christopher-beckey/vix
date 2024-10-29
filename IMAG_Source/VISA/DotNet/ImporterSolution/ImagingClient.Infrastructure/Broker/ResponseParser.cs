// -----------------------------------------------------------------------
// <copyright file="ResponseParser.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: May 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Paul Pentapaty, Duc Nguyen
//  Description: Parsing utils to parse the response from database to data that the application can use
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace ImagingClient.Infrastructure.Broker
{
	using System;
	using System.Collections.Generic;
	using System.Collections.ObjectModel;
	using System.IO;
	using System.Linq;
	using System.Text;
	using System.Text.RegularExpressions;
	using System.Xml;
	using System.Xml.Serialization;
    using log4net;
    using ImagingClient.Infrastructure.User.Model;
    using VistaCommon;

	internal class ResponseParser
	{
        private static readonly ILog Log = LogManager.GetLogger(typeof(BrokerClient));
	
		/// <summary>
		/// Parse the response to get current user information
		/// </summary>
		/// <param name="rawData">raw response about the user infomation retrieved from the database</param>
		internal static void ParseGetUserResponse(string rawData)
		{
			if (string.IsNullOrWhiteSpace(rawData))
			{
				Log.Error("Raw data doesn't have content.");
				return;
			}

			// split the response into lines
			string[] lines = Regex.Split(rawData, "\r\n");
			if ((lines != null) && (lines.Length > 0))
			{
				// the first line will contains all the user information
				string[] caretTokens = lines[0].Split('^');
				if ((caretTokens != null) && (caretTokens.Length >= 10))
				{
					UserContext.UserCredentials.Duz = caretTokens[0];
					UserContext.UserCredentials.Fullname = caretTokens[1];
					UserContext.UserCredentials.Initials = caretTokens[2];
					UserContext.UserCredentials.Ssn = caretTokens[3];
                    UserContext.StationNumber = UserContext.UserCredentials.SiteNumber = UserContext.LocalSite.SiteNumber = caretTokens[4];
                    UserContext.LocalSite.PrimarySiteNumber = caretTokens[5];
					UserContext.LocalSite.SiteAbbreviation = caretTokens[7];
                    UserContext.LocalSite.SiteName = UserContext.UserCredentials.SiteName = caretTokens[8];
					UserContext.LocalSite.IsProductionAccount = (caretTokens[9] == "0") ? false : true;
					UserContext.SiteServiceUrl = caretTokens[6];

                    //TLB - 2FA Implementation:
                    //Don't replace, just update URL in VistA
                    //UserContext.SiteServiceUrl = UserContext.SiteServiceUrl.Replace("SiteService", "ImagingExchangeSiteService");

                    // loging user's information
                    //Commented for p289-OITCOPondiS 
                    //string logmsg = "User's Information:";
                    //logmsg += "|Name: " + UserContext.UserCredentials.Fullname;
                    //logmsg += "|Site Station Number: " + UserContext.LocalSite.SiteNumber;
                    //logmsg += "|Primary Site Station Number: " + UserContext.LocalSite.PrimarySiteNumber;
                    //logmsg += "|Site Name: " + UserContext.LocalSite.SiteName;
                    //logmsg += "|Production Account: " + UserContext.LocalSite.IsProductionAccount.ToString();
                    //logmsg += "|Site Service URL: " + UserContext.SiteServiceUrl;
                    //Log.Info(logmsg);

                    //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                    string logmsg = "User's Information:";
                    logmsg += "|Name: " + (!string.IsNullOrEmpty(caretTokens[1]) ? caretTokens[1] : string.Empty);
                    logmsg += "|Site Station Number: " + UserContext.LocalSite.SiteNumber;
                    logmsg += "|Primary Site Station Number: " + (!string.IsNullOrEmpty(caretTokens[4]) ? caretTokens[4] : string.Empty);
                    logmsg += "|Site Name: " + (!string.IsNullOrEmpty(caretTokens[8]) ? caretTokens[8] : string.Empty);
                    logmsg += "|Production Account: " + (UserContext.LocalSite.IsProductionAccount ? (UserContext.LocalSite.IsProductionAccount.ToString()) : "False");
                    logmsg += "|Site Service URL: " + (!string.IsNullOrEmpty(caretTokens[6]) ? caretTokens[6] : string.Empty);
                    Log.Info(logmsg);
                    //END
				}
				else
				{
					Log.Debug("Missing pieces in User information.");
				}

                //if (lines.Length > 1)
                //{
                //    if (UserContext.UserCredentials.SecurityKeys == null)
                //        UserContext.UserCredentials.SecurityKeys = new List<string>();

                //    string localLRKeys = string.Empty;

                //    // for each subsequence line contains a security keys for the user associate with LAB Package
                //    for (int i = 1; i < lines.Length; i++)
                //    {
                //        if (lines[i] != string.Empty)
                //        {
                //            UserContext.UserCredentials.SecurityKeys.Add(lines[i]);
                //            localLRKeys += Environment.NewLine + lines[i];
                //        }
                //    }

                //    Log.Debug(string.Format("LR Keys:" + Environment.NewLine + "{0}", localLRKeys));
                //}
			}
		}

		internal static List<string> ParseGetUserKeys(string rawData)
		{
			try
			{
				RestStringArrayType keys = DeserializeFromXml<RestStringArrayType>(rawData);
				return new List<string>(keys.Values);
			}
			catch (Exception ex)
			{
				Log.Error("Could not parse response.", ex);
				return new List<string>();
			}
		}

		internal static int ParseGetApplicationTimeout(string rawData)
		{
			if (!string.IsNullOrWhiteSpace(rawData))
			{
				int minutes;
				bool success = int.TryParse(rawData, out minutes);
				if (success)
					return minutes;
				return -1;
			}

			return -1;
		}

        internal static bool ParseSetApplicationTimeout(string rawData)
        {
            if (!string.IsNullOrWhiteSpace(rawData))
            {
                string[] pieces = rawData.Split('^');
                if ((pieces != null) || (pieces.Length >= 1))
                {
                    if (pieces[0] == "1")
                    {
                        return true;
                    }
                }
            }

            return false;
        }

		internal static int ParseGetRetentionDays(string rawData)
		{
			if (!string.IsNullOrWhiteSpace(rawData))
			{
				string[] lines = Regex.Split(rawData.Trim(), "\r\n");
				if ((lines != null) && (lines.Length >= 2))
				{
                    string[] pieces = lines[0].Trim().Split('^');
					if ((pieces != null) && (pieces.Length >= 1) && (pieces[0] == "1"))
					{
						int minutes;
						bool success = int.TryParse(lines[1], out minutes);
						if (success)
							return minutes;

						Log.Error("Value not in right format. " + rawData);
						return -1;
					}

					Log.Error("Error response: " + rawData);
					return -1;
				}

				Log.Error("Eror response: " + rawData);
				return -1;
			}

			return 0;
		}

		/// <summary>
		/// Parse the xml to provide patient information
		/// </summary>
		/// <param name="rawData">raw response from the VIX</param>
		/// <returns>a patient object with all information filled</returns>
		internal static Patient ParseGetPatientInfo(string rawData)
		{
			Patient myPatient;
			try
			{
				myPatient = DeserializeFromXml<Patient>(rawData);
                if (string.IsNullOrWhiteSpace(myPatient.PatientIcn))
                    myPatient.PatientIcn = myPatient.LocalDFN;
				return myPatient;
			}
			catch (Exception ex)
			{
				Log.Error("Could not parse response.", ex);
				return new Patient();
			}
		}

		/// <summary>
		/// Deserialize XML items into custom objects
		/// </summary>
		/// <typeparam name="T">Type of the object to be produced</typeparam>
		/// <param name="xmlContent">xml presentation of the object</param>
		/// <returns>a new object type T initialized with all the information from the xml</returns>
		internal static T DeserializeFromXml<T>(string xmlContent)
		{
			T result;
			XmlSerializer serializer = new XmlSerializer(typeof(T));
			StringReader reader = new StringReader(xmlContent);
			try
			{
				result = (T)serializer.Deserialize(reader);
				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("Failed to deserialize xml string.", ex);
			}
		}

		/// <summary>
		/// Serializing object to xml format
		/// </summary>
		/// <typeparam name="T">Type of the object being serialized</typeparam>
		/// <param name="value">The object being serialized</param>
		/// <returns>XML string representing the object</returns>
		internal static string SerializeToXml<T>(T value)
		{
			string result = string.Empty;

			XmlSerializer serializer = new XmlSerializer(typeof(T));

			XmlWriterSettings settings = new XmlWriterSettings();
			settings.Encoding = new UTF8Encoding(false, false);
			settings.Indent = false;
			settings.OmitXmlDeclaration = true;

			try
			{
				using (StringWriter textWriter = new StringWriter())
				{
					using (XmlWriter xmlWriter = XmlWriter.Create(textWriter, settings))
					{
						serializer.Serialize(xmlWriter, value);
					}
					return textWriter.ToString();
				}
			}
			catch (Exception ex)
			{
				throw new Exception("Serialization failure.", ex);
			}
		}
	}
}
