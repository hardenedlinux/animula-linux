/*  Copyright (C) 2020
 *        "Mu Lei" known as "NalaGinrut" <NalaGinrut@gmail.com>
 *  Lambdachip is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or  (at your option) any later version.

 *  Lambdachip is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.

 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program.
 *  If not, see <http://www.gnu.org/licenses/>.
 */

#include "lambdachip.h"

int main(int argc, char** argv)
{
  /* TODO:
   * 1. Add a REPL shell (include an interpreter)
   * 2. Load file from storage
   * 3. Add a special naming convention, if VM detect them then autorun
   * 4. Add online DEBUG
   */
  os_printk("Platform: %s\n", get_platform_info());
  lambdachip_start();

  return 0;
}
