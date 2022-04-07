import "io"
manifest
{ 
  nodeData = 0,
  nodeNext = 1,
  nodeSize = 2,

  listHead = 0,
  listTail = 1
}

let newList(linkptr) be
{
  let listptr = newvec(2);

  test linkptr = nil then
  {
    listptr ! listHead := nil;
    listptr ! listTail := nil;
  }
  else
  {
    listptr ! listHead := linkptr;
    listptr ! listTail := linkptr;
  }
  resultis listptr;
}

let strcomp(a, b) be
{ 
  let i = 0;
  let ca = byte i of a;
  let cb = byte i of b;
  while ca = cb do
  { 
    if ca = 0 then
      resultis ca - cb;
    i +:= 1;
    ca := byte i of a;
    cb := byte i of b; 
  }
  resultis ca - cb; 
}

let newNode(x) be
{ 
  let p = newvec(nodeSize);
  p ! nodeData := x;
  p ! nodeNext := nil;
  resultis p; 
}
let add(ptr, value) be
{ 
  let n;
  if ptr = nil then
    resultis newNode(value);
  n := newNode(value);
  n ! nodeNext := ptr;
  ptr := n;
  resultis ptr; 
}
let delete(ptr, value) be
{
  let tempptr = ptr;
  let prevptr = nil;
  
  test strcomp(tempptr ! nodeData, value) = 0 then
  {
    ptr := tempptr ! nodeNext;
    freevec(tempptr);
    resultis ptr;
  }
  else
  {
    out("searching\n");
    while tempptr <> nil /\ strcomp(tempptr ! nodeData, value) <> 0 do
    {
      prevptr := tempptr;
      tempptr := tempptr ! nodeNext;
    }
    out("found it, deleting %s\n",tempptr ! nodeData);
    prevptr ! nodeNext := tempptr ! nodeNext;
    freevec(tempptr);
    resultis ptr;
  }
}
let readString(s, max) be
{ 
  let i = 0;
  while true do
  { 
    let c = inch();
    if c < ' ' \/ i > max - 1 then break;
    byte i of s := c;
    i +:= 1; 
  }
  byte i of s := 0; 
}
let printAll(ptr) be
{ 
  let n;
  if ptr = nil then return;
  n := ptr;
  while true do
  { out("%s\n", n ! nodeData);
    if n ! nodeNext = nil then break;
    n := n ! nodeNext; 
  } 
}

let strdup(s) be
{ 
  let size = strlen(s) / 4;
  let d = newvec(size + 1);
  let i = 0;
  until byte i of s = 0 do
  { 
    byte i of d := byte i of s;
    i +:= 1; }
  byte i of d := 0;
  resultis d; 
}

let start() be
{ 
  let heap = vec(15000);
  let s = vec(100);
  let list;
  let x;
  init(heap, 15000);
  list := newList();
  while true do
  { 
    out("Input a string to store into the linked list, type DELETE to delete a word previously entered, type END to stop and display all stored words: ");
    readString(s, 500);

    test strcomp(s, "END") = 0 then break
    else test strcomp(s, "DELETE") = 0 then
    {
      out("Enter word to delete: ");
      readString(s, 500);
      x := strdup(s);
      list := delete(list, x);
      out("Deletion complete. Displaying new list: \n");
      printAll(list);
    }
    else
    {
      x := strdup(s);
      list := add(list, x)
    } 
  }
  printAll(list); 
}
