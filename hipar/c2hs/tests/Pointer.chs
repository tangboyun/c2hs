-- -*-haskell-*-
import Monad
import C2HS

{#pointer string as MyCString foreign newtype#}

cconcat       :: MyCString -> MyCString -> IO MyCString
cconcat s1 s2  = do
  ptr <- {#call concat as _concat#} s1 s2
  liftM MyCString $ newForeignPtr ptr (free ptr)

data Point = Point {
	       x :: Int,
	       y :: Int
	     }

{#pointer *Point as CPoint foreign -> Point#}

-- this is just to exercise some more paths in GenBind.hs
{#pointer *_Point as C_Point foreign -> Point#}
{#pointer PointPtr#}

makeCPoint     :: Int -> Int -> IO CPoint
makeCPoint x y  = do
  ptr <- {#call unsafe make_point#} (cIntConv x) (cIntConv y)
  newForeignPtr ptr (free ptr)

transCPoint :: CPoint -> Int -> Int -> IO CPoint
transCPoint pnt x y = do
  ptr <- {#call unsafe trans_point#} pnt (cIntConv x) (cIntConv y)
  newForeignPtr ptr (free ptr)

-- test function pointers
{#pointer FunPtrFun#}

-- test pointer to pointer
type PtrString = {#type stringPtr#}
checkType :: PtrString -> Ptr (Ptr CChar)
checkType  = id

-- test classes
{#pointer *Point as APoint newtype#}
{#class APointClass APoint#}

{#pointer *ColourPoint as AColourPoint newtype#}
{#class APointClass => AColourPointClass AColourPoint#}


main = putStrLn "This test doesn't compute much; it's all about the generated \
		\types."
