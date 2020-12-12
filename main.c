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
#include <getopt.h>

GLOBAL_DEF (bool, vm_verbose) = false;
GLOBAL_DEF (bool, vm_execute) = false;

GLOBAL_DEF (size_t, VM_CODESEG_SIZE) = 8192;
GLOBAL_DEF (size_t, VM_DATASEG_SIZE) = 2048;
GLOBAL_DEF (size_t, VM_STKSEG_SIZE) = 1024;

int main (int argc, char **argv)
{
  if (1 == argc)
    {
      os_printk (
        "[usage] lambdachip-vm [options] filename.lef\n"
        "options: -v, -m, --code-size=SIZE, --data-size=SIZE, --stack-size=SIZE"
        "\n");
      exit (0);
    }

  static struct option long_options[]
    = {{"code-size", required_argument, 0, 0},
       {"data-size", required_argument, 0, 0},
       {"stack-size", required_argument, 0, 0},
       {0, 0, 0, 0}};

  while (1)
    {
      int option_index = 0;

      const int c = getopt_long (argc, argv, "vx", long_options, &option_index);
      if (-1 == c)
        {
          break;
        }

      const char *const name = long_options[option_index].name;
      switch (c)
        {
        case 0:
          if (optarg)
            {
              char *tail;
              const ssize_t size = strtoul (optarg, &tail, 10);
              if (tail[0] != '\0')
                {
                  os_printk ("Error in parsing command %s = %s\n", name,
                             optarg);
                  exit (-1);
                }
              if (0 == strncmp (name, "code-size", sizeof ("code-size")))
                {
                  GLOBAL_SET (VM_CODESEG_SIZE, size);
                }
              else if (0 == strncmp (name, "data-size", sizeof ("data-size")))
                {
                  GLOBAL_SET (VM_DATASEG_SIZE, size);
                }
              else if (0 == strncmp (name, "stack-size", sizeof ("stack-size")))
                {
                  GLOBAL_SET (VM_STKSEG_SIZE, size);
                }
            }
          else
            {
              os_printk ("Please specify a value to option --%s\n", name);
              exit (-1);
            }

          break;

        case 'v':
          {
            GLOBAL_SET (vm_verbose, true);
            break;
          }
        case 'x':
          {
            GLOBAL_SET (vm_execute, true);
            break;
          }
        default:
          exit (-1);
        }
    }

  /* TODO:
   * 1. Add a REPL shell (include an interpreter)
   * 2. Load file from storage
   * 3. Add a special naming convention, if VM detect them then autorun
   * 4. Add online DEBUG
   */
  VM_DEBUG ("Platform: %s\n", get_platform_info ());

  vm_t vm = lambdachip_init ();

  VM_DEBUG ("Loading LEF image from %s......\n", argv[optind]);
  lef_t lef = load_lef_from_file (argv[optind]);
  vm_load_lef (vm, lef);
  free_lef (lef);
  vm_run (vm);

  lambdachip_clean (vm);
  return 0;
}
