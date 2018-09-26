!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!! FEAST Driver sparse example - CSR Format 
!!!!!!! solving Ax=ex with A complex-symmetric (non-Hermitian)
!!!!!!! James Kestyn, Eric Polizzi 2015
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
program driver

  implicit none
!!!!!!!!!!!!!!!!! Feast declaration variable
  integer,dimension(64) :: feastparam 
  integer :: loop
  character(len=1) :: UPLO='F'

!!!!!!!!!!!!!!!!! Matrix declaration variable
  character(len=100) :: name
  integer :: n,nnz
  complex(kind=kind(1.0d0)),dimension(:),allocatable :: sa
  integer,dimension(:),allocatable :: isa,jsa

!!!!!!!!!!!!!!!!! Contour
  integer :: ccN
  complex(kind=kind(1.0d0)),dimension(:),allocatable :: Zne, Wne, Zedge
  integer, dimension(:), allocatable :: Nedge, Tedge 

!!!!!!!!!!!!!!!!! FEAST
  integer :: M0,M,info
  complex(kind=kind(1.0d0)) :: Emid
  double precision :: r,epsout
  complex(kind=(kind(1.0d0))),dimension(:),allocatable :: E ! eigenvalue+residual
  complex(kind=kind(1.0d0)),dimension(:,:),allocatable :: XR ! eigenvectors
  double precision,dimension(:),allocatable :: resr ! eigenvalue+residual

!!!!!!!!!!!!!!!!! Others
  integer :: t1,t2,tim
  integer :: i,j,k
  double precision :: Emin,Emax,rea,img
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!! read input file in csr format!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  name='../../system4'

!!!!!!!!!! form CSR arrays isa,jsa,sa 
  open(10,file=trim(name),status='old')
  read(10,*) n,nnz
  allocate(isa(1:N+1))
  isa=0
  isa(1)=1
  allocate(jsa(1:nnz))
  allocate(sa(1:nnz))
  do k=1,nnz
     read(10,*) i,jsa(k),rea,img
     sa(k)=rea*(1.0d0,0.0d0)+img*(0.0d0,1.0d0)
     isa(i+1)=isa(i+1)+1
  end do
  close(10)
  do i=2,n+1
     isa(i)=isa(i)+isa(i-1)
  enddo


!!!!!!!!!!!!!!!!!!!!!! INFORMATION ABOUT MATRIX !!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  print *,'sparse matrix -system4- size',n
  print *,'nnz',nnz


  call system_clock(t1,tim)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!! FEAST in sparse format !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!!! custom contour
  call feastinit(feastparam)
  feastparam(1)=1
  feastparam(6)=1
  M0=50 !! M0>=M

  Emid = (4.0d0,0.0d0)
  r = 3.0d0


!!!!!!!!!!!!! ALLOCATE VARIABLE 
  allocate(e(1:M0))     ! Eigenvalue
  allocate(XR(1:n,1:M0)) ! Eigenvectors
  allocate(resr(1:M0))   ! Residual (if needed)

  call zfeast_scsrev(UPLO,N,sa,isa,jsa,feastparam,epsout,loop,Emid,r,M0,E,XR,M,resr,info)


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!! POST-PROCESSING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  call system_clock(t2,tim)
  print *,'FEAST OUTPUT INFO',info
  !if (info==0) then
     print *,'*************************************************'
     print *,'************** REPORT ***************************'
     print *,'*************************************************'
     print *,'SIMULATION TIME',(t2-t1)*1.0d0/tim
     print *,'# Search interval [Emid,r]',Emid,r
     print *,'# mode found/subspace',M,M0
     print *,'# iterations',loop
     print *,'TRACE',sum(E(1:M))
     print *,'Relative error on the Trace',epsout
     print *,'Eigenvalues/Residuals'
     do i=1,M
        print *,i,E(i),resr(i)
     enddo
 ! endif

end program driver


