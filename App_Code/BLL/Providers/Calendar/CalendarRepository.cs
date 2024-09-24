#region XD World Recipe V 3
// FileName: CalendarRepository.cs
// Author: Dexter Zafra
// Date Created: 6/30/2008
// Website: www.ex-designz.net
#endregion
using System;
using XDRecipe.Model;

namespace XDRecipe.BL
{
    /// <summary>
    /// Objects in this class manages Add, Update and Delete Recipe
    /// </summary>
    public class CalendarRepository : BaseCalendarObj
    {
        /// <summary>
        /// Default Constructor
        /// </summary>
        public CalendarRepository()
        {
        }

        /// <summary>
        /// Perform Insert to Database
        /// </summary>
        /// <returns></returns>
        public override int Add(Calendar Calendar)
        {
            return Blogic.ActionProcedureDataProvider.AddCalendar(Calendar);
        }

        /// <summary>
        /// Perform Update
        /// </summary>
        /// <returns></returns>
        public override int Update(Calendar Calendar)
        {
            return Blogic.ActionProcedureDataProvider.UpdateCalendar(Calendar);
        }

        /// <summary>
        /// Perform Delete
        /// </summary>
        /// <returns></returns>
        public override int Delete(Calendar Calendar)
        {
            return Blogic.ActionProcedureDataProvider.AdminDeleteCalendar(Calendar);
        }

        /// <summary>
        /// Perform Insert to Database
        /// </summary>
        /// <returns></returns>
        public override int AddCategory(Calendar category)
        {
            return Blogic.ActionProcedureDataProvider.AdminAddNewCalendarCategory(category);
        }

        /// <summary>
        /// Perform Update
        /// </summary>
        /// <returns></returns>
        public override int UpdateCategory(Calendar category)
        {
            return Blogic.ActionProcedureDataProvider.UpdateCalendarCategory(category);
        }

        /// <summary>
        /// Perform Delete
        /// </summary>
        /// <returns></returns>
        public override int DeleteCategory(Calendar category)
        {
            return Blogic.ActionProcedureDataProvider.AdminDeleteCalendarCategory(category);
        }

    }
}
