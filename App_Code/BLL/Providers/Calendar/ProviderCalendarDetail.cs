#region XD World Recipe V 3
// FileName: ProviderCalendarDetail.cs
// Author: Dexter Zafra
// Date Created: 5/29/2008
// Website: www.ex-designz.net
#endregion
using System;
using System.Data;
using XDRecipe.BL;
using XDRecipe.Common;
using XDRecipe.Model;
using XDRecipe.Common.Utilities;

namespace XDRecipe.BL.Providers.Calendar
{
    /// <summary>
    /// Objects in this class manages return the Calendar details
    /// </summary>
    public sealed class ProviderCalendarDetails : BaseCalendarObj
    {
        public ProviderCalendarDetails()
        {
        }

        /// <summary>
        /// Get Calendar title, author, date, hits, rating and content from the DB matching the Calendar ID provided.
        /// </summary>
        public override void FillUp(int ID)
        {
            IDataReader dr = Blogic.ActionProcedureDataProvider.GetCalendarDetail(ID, Approved);

            while (dr.Read())
            {
                if (dr["ID"] != DBNull.Value)
                {
                    this._ID = (int)dr["ID"];
                }
                if (dr["Title"] != DBNull.Value)
                {
                    this._Title = (string)dr["Title"];
                }
                if (dr["Author"] != DBNull.Value)
                {
                    this._Author = (string)dr["Author"];
                }
                if (dr["No_Rates"] != DBNull.Value)
                {
                    this._NoRates = dr["No_Rates"].ToString();
                }
                if (dr["HITS"] != DBNull.Value)
                {
                    this._Hits = (int)dr["HITS"];
                }
                if (dr["Rates"] != DBNull.Value)
                {
                    this._Rating = dr["Rates"].ToString();
                }
                if (dr["Content"] != DBNull.Value)
                {
                    this._Content = (string)dr["Content"];
                }
                if (dr["CAT_NAME"] != DBNull.Value)
                {
                    this._Category = (string)dr["CAT_NAME"];
                }
                if (dr["CAT_ID"] != DBNull.Value)
                {
                    this._CatID = (int)dr["CAT_ID"];
                }
                if (dr["Post_Date"] != DBNull.Value)
                {
                    this._Date = (DateTime)(dr["Post_Date"]);
                }
                if (dr["UID"] != DBNull.Value)
                {
                    this._UID = (int)dr["UID"];
                }
                if (dr["Summary"] != DBNull.Value)
                {
                    this._Summary = (string)dr["Summary"];
                }
                if (dr["Keyword"] != DBNull.Value)
                {
                    this._Keyword = (string)dr["Keyword"];
                }
                if (dr["Total_Comments"] != DBNull.Value)
                {
                    this._CountComments = (int)dr["Total_Comments"];
                }

            }
            dr.Close();
            dr = null;
        }
    }
}