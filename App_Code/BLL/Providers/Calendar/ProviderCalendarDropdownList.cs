#region XD World Recipe V 3
// FileName: ProviderCalendarDropdownList.cs
// Author: Dexter Zafra
// Date Created: 6/19/2008
// Website: www.ex-designz.net
#endregion
using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Collections;
using XDRecipe.BL;
using XDRecipe.Common;
using XDRecipe.Model;

namespace XDRecipe.BL.Providers.Calendar
{
    /// <summary>
    /// Object in this class populate Calendar category dropdownlist.
    /// </summary>
    public sealed class ProviderCalendarCategoryDropdown
    {
        public ProviderCalendarCategoryDropdown()
        {
        }

        private Hashtable _CategoryListCalendar;

        /// <summary>
        /// Return a hashtable of Calendar category
        /// </summary>
        public Hashtable categoryListCalendar
        {
            get
            {
                if (_CategoryListCalendar == null)
                    createCategoryListCalendar();
                return _CategoryListCalendar;
            }
        }

        /// <summary>
        /// Create a hashtable for Calendar Category dropdownlist
        /// </summary>
        private void createCategoryListCalendar()
        {
            IDataReader dr = Blogic.ActionProcedureDataProvider.GetCalendarCategoryList;

            try
            {
                Hashtable ht = new Hashtable();
                while (dr.Read())
                {
                    ht.Add(dr["CAT_ID"].ToString(), dr["CAT_NAME"].ToString());

                    _CategoryListCalendar = ht;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            dr.Close();
        }
    }
}