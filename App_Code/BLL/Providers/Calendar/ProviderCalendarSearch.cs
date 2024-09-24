#region XD World Recipe V 3
// FileName: ProviderCalendarSearch.cs
// Author: Dexter Zafra
// Date Created: 8/22/2008
// Website: www.ex-designz.net
#endregion
using System;
using System.Data;
using XDRecipe.BL;
using XDRecipe.Common;
using System.Data.SqlClient;
using XDRecipe.Model;

namespace XDRecipe.BL.Providers.Calendar
{
    /// <summary>
    /// object in this class manages Calendar search result object List collection
    /// </summary>
    public sealed class CalendarSearchProvider : Calendar
    {
        /// <summary>
        /// Returns database connection string.
        /// </summary>
        private static string ConnectionString
        {
            get
            {
                try
                {
                    return System.Configuration.ConfigurationManager.ConnectionStrings["strConn"].ConnectionString;
                }
                catch (Exception ex)
                {
                    //throw new ApplicationException("Unable to get Database Connection string from Web Config File. Contact the site Administrator" + ex);
                }
            }
        }
        
        public static readonly CalendarSearchProvider Instance = new CalendarSearchProvider();
 
        static CalendarSearchProvider() 
        {
        }

        CalendarSearchProvider() 
        { 
        }

        public static CalendarSearchProvider GetInstance()
        {
          return Instance;
        }

        public void CalendarSearchParam(string Keyword, int CatId, int OrderBy, int SortBy, int PageIndex, int PageSize)
        {
            try
            {
            	
            SqlConnection cn = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("SELECT * FROM Events e, PrivateMessage pm, Recipes r where r.ingredients = 'leek' and pm.M_Subject like'%leek%'", cn);
            DataTable dt = new DataTable();
            IDataReader dr;
          	cmd.CommandType = CommandType.StoredProcedure;
						
            cn.Open();

            this._CatID = CatId;
            this._Keyword = Keyword;
            this._OrderBy = OrderBy;
            this._SortBy = SortBy;
            this._Index = PageIndex;
            this._PageSize = PageSize;

            IDataReader dr = GetData;

            dr.Read();

            //Get category name and record count
            this._RecordCount = (int)dr["RCount"];
            this._Category = (string)dr["CAT_NAME"];

            dr.Close();
            }
          	catch (Exception e)
          	{
          		
          	}
        }

        /// <summary>
        /// Return Data
        /// </summary>
        /// <returns></returns>
        public IDataReader GetData
        {
            get
            {
                //Get data
                IDataReader dr = Blogic.ActionProcedureDataProvider.GetCalendarSearchResult(Keyword, CatID, OrderBy, SortBy, Index, PageSize);
                return dr;
            }
        }

        public ExtendedCollection<Calendar> GetCalendarSearchResult()
        {
            ExtendedCollection<Calendar> list = new ExtendedCollection<Calendar>();

            IDataReader dr = GetData;

            while (dr.Read())
            {
                Calendar item = new Calendar();

                item.ID = (int)dr["ID"];

                if (dr["Title"] != DBNull.Value)
                {
                    item.Title = (string)dr["Title"];
                }
                if (dr["CAT_NAME"] != DBNull.Value)
                {
                    item.Category = (string)dr["CAT_NAME"];
                }
                if (dr["Author"] != DBNull.Value)
                {
                    item.Author = (string)dr["Author"];
                }
                if (dr["Summary"] != DBNull.Value)
                {
                    item.Summary = (string)dr["Summary"];
                }
                if (dr["Rates"] != DBNull.Value)
                {
                    item.Rating = dr["Rates"].ToString();
                }
                if (dr["No_Rates"] != DBNull.Value)
                {
                    item.NoRates = dr["No_Rates"].ToString();
                }
                if (dr["Post_Date"] != DBNull.Value)
                {
                    item.Date = (DateTime)(dr["Post_Date"]);
                }
                if (dr["HITS"] != DBNull.Value)
                {
                    item.Hits = (int)dr["HITS"];
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
