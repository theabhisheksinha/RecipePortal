#region XD World Recipe V 3
// FileName: ProviderUnapprovedCalendar.cs
// Author: Dexter Zafra
// Date Created: 2/26/2009
// Website: www.ex-designz.net
#endregion
using System;
using System.Web;
using System.Data;
using XDRecipe.BL;
using XDRecipe.Common;
using XDRecipe.Model;

namespace XDRecipe.BL.Providers.Calendar
{
    /// <summary>
    /// object in this class returns unapproved Calendars
    /// </summary>
    public static class ProviderUnapprovedCalendars
    {

        /// <summary>
        /// Return Recipe Category Data
        /// </summary>
        private static IDataReader GetData
        {
            get
            {
                //Get data
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetUnApprovedCalendar;
                return dr;
            }
        }

        /// <summary>
        /// Return unapproved Calendars
        /// </summary>
        public static ExtendedCollection<Calendar> GetUnApprovedCalendars()
        {
            ExtendedCollection<Calendar> list = new ExtendedCollection<Calendar>();

            IDataReader dr = GetData;

            while (dr.Read())
            {
                Calendar item = new Calendar();

                if (dr["ID"] != DBNull.Value)
                {
                    item.ID = (int)(dr["ID"]);
                }
                if (dr["CAT_NAME"] != DBNull.Value)
                {
                    item.Category = (string)dr["CAT_NAME"];
                }
                if (dr["Title"] != DBNull.Value)
                {
                    item.Title = (string)dr["Title"];
                }
                if (dr["Post_Date"] != DBNull.Value)
                {
                    item.Date = (DateTime)dr["Post_Date"];
                }
                if (dr["Author"] != DBNull.Value)
                {
                    item.Author = (string)dr["Author"];
                }
                if (dr["UID"] != DBNull.Value)
                {
                    item.UID = (int)dr["UID"];
                }

                list.Add(item);
            }

            dr.Close();

            return list;
        }
    }
}
