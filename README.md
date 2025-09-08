# Advent of Code Zig Starter

A template for [Advent of Code](https://adventofcode.com) written in Zig (updated to `zig 0.15.1`).

- [Day 01](src/day01)
- [Day 02](src/day02)
- [Day 03](src/day03)
- [Day 04](src/day04)
- [Day 05](src/day05)
- [Day 06](src/day06)
- [Day 07](src/day07)
- [Day 08](src/day08)
- [Day 09](src/day09)
- [Day 10](src/day10)
- [Day 11](src/day11)
- [Day 12](src/day12)
- [Day 13](src/day13)
- [Day 14](src/day14)
- [Day 15](src/day15)
- [Day 16](src/day16)
- [Day 17](src/day17)
- [Day 18](src/day18)
- [Day 19](src/day19)
- [Day 20](src/day20)
- [Day 21](src/day21)
- [Day 22](src/day22)
- [Day 23](src/day23)
- [Day 24](src/day24)
- [Day 25](src/day25)

## Usage

The project has the following commands, `generate`, `fetch`, `dayXX-run`, `dayXX-test` and `dayXX-install` where `XX` is the day number.
You can see the available commands with:

    $ zig build -h

### Generate template files

You can generate the template files using the `zig build generate` with the `-Dday` flag:

    $ zig build generate -Dday=1
    Advent of Code 2024
    * creating src/day01/main.zig
    * creating src/day01/part_one.zig
    * creating src/day01/part_two.zig
    * creating src/day01/parser.zig
    * creating src/day01/README.md

If you have the `AOC_SESSION_TOKEN` environment variable setted, the `zig build generate` with the `-Dyear` and `-Dday` also downloads the puzzle:

    $ zig build generate -Dyear=2024 -Dday=1
    Advent of Code 2024
    * creating src/day01/main.zig
    * creating src/day01/part_one.zig
    * creating src/day01/part_two.zig
    * creating src/day01/parser.zig
    * creating src/day01/README.md
    * creating src/day01/puzzle.txt

If the files already exist, they will not be replaced.

    $ zig build generate -Dyear=2024 -Dday=1
    Advent of Code 2024
    * ignoring src/day01/main.zig already exists
    * ignoring src/day01/part_one.zig already exists
    * ignoring src/day01/part_two.zig already exists
    * ignoring src/day01/parser.zig already exists
    * ignoring src/day01/README.md already exists
    * ignoring src/day01/puzzle.txt already exists

### Fetch puzzle (optional)

Using the command `zig build fetch` with the flags `-Dyear` and `-Dday`, and the `AOC_SESSION_TOKEN` environment variable, you can download the puzzle into the project:

    $ zig build fetch -Dyear=2024 -Dday=1
    Advent of Code 2024
    * creating src/day01/puzzle.txt

### Usage in the live event

 If you are participating in the live event, is not necesary to use the flags, for example, if the current time is 2024-12-17 (UTC-5), you can execute `zig build generate` and `zig build fetch` without the flags and the result will be:

    $ zig build generate
    Advent of Code 2024
    * creating src/day17/main.zig
    * creating src/day17/part_one.zig
    * creating src/day17/part_two.zig
    * creating src/day17/parser.zig
    * creating src/day17/README.md

    $ zig build fetch
    Advent of Code 2024
    * creating src/day17/puzzle.txt

### run, test, and install

You can run, test or install the challenge using the `dayXX-run`, `dayXX-test` and `dayXX-install` commands:

    # only run the day01
    $ zig build day01-run

    # only test the day02
    $ zig build day02-test

    # only install the day03
    $ zing build day03-install

Also, you can execute the `run` and `test` commands in watch mode:

    # only test the day02
    $ zig build --watch day02-test

    Build Summary: 5/5 steps succeeded; 2/2 tests passed
    day02-test success
    ├─ run test day02 part_one 1 passed 261us MaxRSS:2M
    └─ run test day02 part_two 1 passed 249us MaxRSS:2M

Folder structure:

    src
    └── day01
        ├── main.zig
        ├── parser.zig
        ├── part_one.zig
        ├── part_two.zig
        ├── puzzle.txt
        └── README.md

Happy coding!

[MIT License](LICENSE)
