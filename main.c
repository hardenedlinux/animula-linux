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

GLOBAL_DEF(bool, vm_verbose) = false;
GLOBAL_DEF(bool, vm_execute) = false;

int main(int argc, char** argv)
{
  if (1 == argc)
    {
      os_printk("[usage] lambdachip-vm [-vx] filename.lef\n");
      exit(0);
    }

#if defined LAMBDACHIP_LINUX
  int c;
  while ((c = getopt(argc, argv, "vx")) != -1)
    switch (c)
      {
      case 'v':
        {
          GLOBAL_SET(vm_verbose, true);
          break;
        }
      case 'x':
        {
          GLOBAL_SET(vm_execute, true);
          break;
        }
      default:
        exit(-1);
      }
#endif

  /* TODO:
   * 1. Add a REPL shell (include an interpreter)
   * 2. Load file from storage
   * 3. Add a special naming convention, if VM detect them then autorun
   * 4. Add online DEBUG
   */
  VM_DEBUG("Platform: %s\n", get_platform_info());

  vm_t vm = lambdachip_init();

  VM_DEBUG("Loading LEF image from %s......\n", argv[optind]);
  lef_t lef = load_lef_from_file(argv[optind]);
  os_printk("psize: %d\n", lef->psize);
  os_memcpy(vm->code, LEF_PROG(lef), lef->psize);
  vm_run(vm);

  return 0;
}
